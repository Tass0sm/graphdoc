module Text.Graphdoc.Graph.Definition
  ( NodeID
  , DocTree
  , DocEnv ) where

import Data.Map
import Data.Text
import Data.Tree

type NodeID = Int
type NodeContent = Text

type DocTree = Tree NodeID
type DocEnv = ( Map FilePath NodeID
              , Map NodeID FilePath
              , Map NodeID NodeContent )

-- type a = Reader DocEnv a
