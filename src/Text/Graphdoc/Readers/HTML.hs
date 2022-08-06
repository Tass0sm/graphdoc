module Text.Graphdoc.Readers.HTML
  ( readHTML ) where

import Text.Graphdoc.Definition
import Text.Graphdoc.Class
import Control.Monad.IO.Class
import Control.Monad.Reader
import Control.Monad.Identity
import Data.Tree
import Data.Maybe
import Data.Monoid
import qualified Data.Text as T
import qualified Data.Map as M
import System.Directory.Tree

import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Graph.Utils

readHTML :: GraphSource -> GraphdocIO Graphdoc
readHTML s = do
  -- let docEnv = getDocEnv s
  -- let skeleton = runReader getSkeleton docEnv
  liftIO $ print $ getGraph s
  return $ Graphdoc mempty (Node (GraphdocNode (Title mempty) mempty mempty) [])

getSkeleton :: GraphSource -> (Tree T.Text)
getSkeleton = undefined
  -- t <- getTree
  -- traverse idToContent t
  -- undefined

getTree :: GraphSource -> DocTree
getTree = undefined
  -- g <- getGraph
  -- return $ orderedDFS g
  -- undefined

getGraph :: GraphSource -> M.Map FilePath [(Edge, FilePath)]
getGraph = M.fromList . map file . filter isFile . flattenDir . fmap adjacencies . zipPaths
  where isFile (File _ _) = True
        isFile _ = False

adjacencies :: (FilePath, T.Text) -> (FilePath, [(Edge, FilePath)])
adjacencies (p, c) = (p, absoluteLinks p c)

absoluteLinks :: FilePath -> T.Text -> [(Edge, FilePath)]
absoluteLinks ctx f = catMaybes $ map (absoluteLink ctx) (linkLines f)

absoluteLink :: FilePath -> T.Text -> Maybe (Edge, FilePath)
absoluteLink ctx t = do
  (e, rp) <- relativeLink t
  return (e, makeAbsolute ctx rp)

-- TODO
makeAbsolute :: FilePath -> FilePath -> FilePath
makeAbsolute ctx rp = rp

relativeLink :: T.Text -> Maybe (Edge, FilePath)
relativeLink t = let (rel, href) = parseLinkLine t
  in case (T.unpack rel) of
       "PREV" -> Just (Prev, T.unpack href)
       "UP" -> Just (Up, T.unpack href)
       "NEXT" -> Just (Fwd, T.unpack href)
       otherwise -> Nothing

parseLinkLine :: T.Text -> (T.Text, T.Text)
parseLinkLine l = let relRs = snd $ T.breakOn (T.pack "REL=") l
                      (rel, hrefRs) = T.breakOn (T.pack " HREF=") relRs
                      href = fst $ T.breakOn (T.pack ">") hrefRs
                  in (T.drop 4 rel, T.dropEnd 1 $ T.drop 8 href)

linkLines :: T.Text -> [T.Text]
linkLines t = Prelude.filter (T.isPrefixOf (T.pack "<LINK")) $ T.lines t
