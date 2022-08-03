module Text.Graphdoc.Readers.HTML
  ( readHTML ) where

import Text.Graphdoc.Definition
import Text.Graphdoc.Class
import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Tree
import Data.Maybe
import qualified Data.Text as T
import qualified Data.Map as M

import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Graph.Utils

readHTML :: GraphSource -> GraphdocIO Graphdoc
readHTML s = do
  let docEnv = getDocEnv s
  let skeleton = runReader getSkeleton docEnv
  undefined

getSkeleton :: Reader DocEnv (Tree T.Text)
getSkeleton = do
  t <- getTree
  traverse getContent t

getTree :: Reader DocEnv DocTree
getTree = do
  g <- getGraph
  return $ orderedDFS g

getGraph :: Reader DocEnv DocGraph
getGraph = do
  files <- M.keys <$> ask
  fromAdjacencies <$> concat <$> traverse getAdjacencies files

getAdjacencies :: NodeID -> Reader DocEnv [(Edge, NodeID)]
getAdjacencies = undefined
