module Text.Graphdoc.Graph.Utils
  ( fromAdjacencies
  , orderedDFS
  , getContent
  , getDocEnv ) where

import System.Directory.Tree
import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Definition
import Control.Monad.Reader
import qualified Data.Map as M
import qualified Data.Text as T
import Data.Maybe

fromAdjacencies :: [(Edge, NodeID)] -> DocGraph
fromAdjacencies = undefined

orderedDFS :: DocGraph -> DocTree
orderedDFS g = undefined

getContent :: NodeID -> Reader DocEnv T.Text
getContent n = do
  t <- asks $ M.lookup n
  return $ fromMaybe (T.pack "") t

getDocEnv :: GraphSource -> DocEnv
getDocEnv = M.fromList . zip [0..] . map file . filter isFile . flattenDir . dirTree
  where isFile (File _ _) = True
        isFile _ = False
