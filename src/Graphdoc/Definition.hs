module Graphdoc.Definition
  ( DocGraph ) where

import Algebra.Graph.Labelled
import Data.Text (Text)

-- All the information for a node in the graph (metadata and source).
data Meta = Meta
  { metaFormat :: String
  } deriving (Show)

data DocSource = File FilePath |
                 Body Text

-- The node type
type DocNode = (Meta, DocSource)

-- A labelled graph of nodes, which captures a body of documentation.
type DocGraph = Graph String DocNode
