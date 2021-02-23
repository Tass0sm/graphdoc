module Graphdoc.Definition
  ( DocGraph
  , DocSource (..)
  , DocNode
  , DocEdge
  , Meta (..) ) where

import Algebra.Graph.Labelled
import Text.Pandoc.Definition
import Data.Text (Text)

-- All the information for a node in the graph (metadata and source).
data Meta = Meta
  { metaFormat :: String
  , metaTitle  :: String
  , metaPath   :: FilePath
  } deriving (Show)

data DocSource = File FilePath |
                 Body Text |
                 Doc Pandoc

-- The node type
type DocNode = (Meta, DocSource)

-- A standalone edge, for building graphs
type DocEdge = (String, DocNode, DocNode)

-- A labelled graph of nodes, which captures a body of documentation.
type DocGraph = Graph String DocNode
