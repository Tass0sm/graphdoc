module Text.Graphdoc.Graph.Definition
  ( Edge
  , NodeID
  , DocGraph
  , DocTree
  , DocEnv ) where

import Data.Map
import Data.Text
import Data.Tree

type NodeID = Int
type NodeContent = Text

data Edge = Up | Fwd | Prev
type DocGraph = Map NodeID [(Edge, NodeID)]
type DocTree = Tree NodeID
type DocEnv = Map NodeID NodeContent

-- type a = Reader DocEnv a
