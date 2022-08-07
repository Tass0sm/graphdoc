module Text.Graphdoc.Readers.HTML
  ( readHTML
  , makeAbsolute
  , getTop
  , getGraph ) where

import Text.Graphdoc.Definition
import Text.Graphdoc.Class
import Control.Monad.IO.Class
import Control.Monad.Reader
import Control.Monad.Identity
import Data.List
import Data.Tree
import Data.Maybe
import Data.Monoid
import qualified Data.Text as T
import qualified Data.Map as M
import System.Directory.Tree
import System.FilePath

import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Graph.Utils

readHTML :: GraphSource -> GraphdocIO Graphdoc
readHTML s = do
  -- let docEnv = getDocEnv s
  -- let skeleton = runReader getSkeleton docEnv
  liftIO $ putStrLn $ drawTree $ getTree s
  return $ Graphdoc mempty (Node (GraphdocNode (Title mempty) mempty mempty) [])

getSkeleton :: GraphSource -> (Tree T.Text)
getSkeleton s = let t = getTree s
                in fmap undefined t

getTree :: GraphSource -> Tree FilePath
getTree s = let g = getGraph s
                start = getTop g
                trans = transposeGraph g
            in orderedDFS trans start

getTop :: M.Map FilePath [(Edge, FilePath)] -> FilePath
getTop g = let start = head $ M.toList g
               topEdge = find ((Top==) . fst) $ snd start
           in fromJust $ snd <$> topEdge

noLinks :: (FilePath, [(Edge, FilePath)]) -> Bool
noLinks (_, []) = False
noLinks _ = True

getGraph :: GraphSource -> M.Map FilePath [(Edge, FilePath)]
getGraph = M.fromList . filter noLinks . map file . filter isFile . flattenDir . fmap adjacencies . zipPaths
  where isFile (File _ _) = True
        isFile _ = False

adjacencies :: (FilePath, T.Text) -> (FilePath, [(Edge, FilePath)])
adjacencies (p, c) = (p, absoluteLinks (takeDirectory p) c)

absoluteLinks :: FilePath -> T.Text -> [(Edge, FilePath)]
absoluteLinks ctx f = catMaybes $ map (absoluteLink ctx) (linkLines f)

absoluteLink :: FilePath -> T.Text -> Maybe (Edge, FilePath)
absoluteLink ctx t = do
  (e, rp) <- relativeLink t
  return (e, makeAbsolute ctx rp)

makeAbsolute :: FilePath -> FilePath -> FilePath
makeAbsolute ctx rp = joinPath $ makeAbsolute' (splitPath ctx) (splitPath rp)

-- This just resolves .., It assumes no symlinks. Eventually will use anchored dir tree better.
makeAbsolute' :: [FilePath] -> [FilePath] -> [FilePath]
makeAbsolute' ctxs  ("../":rps) = makeAbsolute' (init ctxs) rps
makeAbsolute' ctxs (rp:rps) = makeAbsolute' (ctxs ++ [rp]) rps
makeAbsolute' ctxs rp = ctxs ++ rp

relativeLink :: T.Text -> Maybe (Edge, FilePath)
relativeLink t = let (rel, href) = parseLinkLine t
  in case (T.unpack rel) of
       "PREV" -> Just (Prev, T.unpack href)
       "UP" -> Just (Up, T.unpack href)
       "NEXT" -> Just (Fwd, T.unpack href)
       "TOP" -> Just (Top, T.unpack href)
       otherwise -> Nothing

parseLinkLine :: T.Text -> (T.Text, T.Text)
parseLinkLine l = let relRs = snd $ T.breakOn (T.pack "REL=") l
                      (rel, hrefRs) = T.breakOn (T.pack " HREF=") relRs
                      href = fst $ T.breakOn (T.pack ">") hrefRs
                  in (T.drop 4 rel, T.dropEnd 1 $ T.drop 7 href)

linkLines :: T.Text -> [T.Text]
linkLines t = Prelude.filter (T.isPrefixOf (T.pack "<LINK")) $ T.lines t
