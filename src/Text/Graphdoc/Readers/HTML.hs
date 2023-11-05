module Text.Graphdoc.Readers.HTML
  ( readHTML
  , makeAbsolute
  , getTop
  , getGraph' ) where

import Text.Graphdoc.Definition
import Text.Graphdoc.Class
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Reader
import Control.Monad.Identity
import Data.Foldable
import Data.List
import Data.Tree
import Data.Maybe
import Data.Monoid
import Data.Graph.Inductive.PatriciaTree
import qualified Data.Graph.Inductive as FGL
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
  liftIO $ putStrLn $ drawTree $ show <$> getTree s
  return $ Graphdoc mempty (Node (GraphdocNode (Title mempty) mempty mempty) [])

getSkeleton :: GraphSource -> (Tree T.Text)
getSkeleton s = let t = getTree s
                in fmap undefined t

getTree :: GraphSource -> Tree FGL.Node
getTree s = let g = getGraph' s :: Gr (FilePath, T.Text) Edge
                start = fromJust $ getTop g
            in orderedDFS' (transposeGraph g) start

getTop :: FGL.DynGraph gr => gr (FilePath, T.Text) Edge -> Maybe FGL.Node
getTop g = do
  let goesToTop (_, _, e) = e == Top
  (_, t, _) <- find goesToTop (FGL.labEdges g)
  return t

-- Rewrite:

type FilePathEnv = M.Map FilePath FGL.Node

getFilePathToNodeMap :: GraphSource -> FilePathEnv
getFilePathToNodeMap s = M.fromList $ zip (map fst $ toList $ zipPaths s) [1..]

getGraph' :: FGL.DynGraph gr => GraphSource -> gr (FilePath, T.Text) Edge
getGraph' s = runReader buildGraphM (getFilePathToNodeMap s)
  where buildGraphM = do
          let zippedSource = zipPaths s
          g' <- foldM addNode FGL.empty zippedSource
          g <- foldM addEdges g' zippedSource
          return g

addNode :: FGL.DynGraph gr => gr (FilePath, T.Text) Edge -> (FilePath, T.Text) -> Reader FilePathEnv (gr (FilePath, T.Text) Edge)
addNode g (p, t) = do
  mNodeID <- asks $ M.lookup p
  case mNodeID of
    Just nodeID -> return $ FGL.insNode (nodeID, (p, t)) g
    Nothing -> return g

addEdges :: FGL.DynGraph gr => gr (FilePath, T.Text) Edge -> (FilePath, T.Text) -> Reader FilePathEnv (gr (FilePath, T.Text) Edge)
addEdges g (p, t) = do
  edges <- htmlEdges p t
  return $ FGL.insEdges edges g

htmlEdges :: FilePath -> T.Text -> Reader FilePathEnv [FGL.LEdge Edge]
htmlEdges p t = do
  let (s, adjs) = adjacencies (p, t)
  mSourceID <- asks $ M.lookup s
  case mSourceID of
    Just sourceID -> convertAll sourceID adjs
    Nothing -> return []

convertAll :: FGL.Node -> [(Edge, FilePath)] -> Reader FilePathEnv [FGL.LEdge Edge]
convertAll s es = do
  targetNodeIds <- mapM (convertSingle s) es
  return $ catMaybes targetNodeIds

convertSingle :: FGL.Node -> (Edge, FilePath) -> Reader FilePathEnv (Maybe (FGL.LEdge Edge))
convertSingle n (e, f) = do
  mt <- asks $ M.lookup f
  case mt of
    Just t -> return $ Just (n, t, e)
    Nothing -> return Nothing

-- Getting Edges

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

