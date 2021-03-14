{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Output.Util
    ( dfsWithDepth ) where

import Graphdoc.Definition

import Data.Text
import Data.Tree
import Algebra.Graph.AdjacencyMap
import Algebra.Graph.AdjacencyMap.Algorithm
import Control.Monad

import qualified Data.Text.IO as TIO
import System.IO

flattenWithDepth :: Tree a -> [(Int, a)]
flattenWithDepth t = squish 1 t []
  where squish depth (Node x ts) xs = (depth, x):Prelude.foldr (squish $ (+1) depth) xs ts

dfsWithDepth :: Ord a => [a] -> AdjacencyMap a -> [(Int, a)]
dfsWithDepth vs = dfsForestFrom vs >=> flattenWithDepth
