module Graphdoc.Definition
  ( DocGraph
  , DocSource (..)
  , DocNode (..)
  , DocEdge
  , DocMeta (..) ) where

import Algebra.Graph.Labelled.AdjacencyMap
import Text.Pandoc.Definition
import Data.Text (Text)

-- All the information for a node in the graph (metadata and source).
data DocMeta = DocMeta
  { docMetaFormat :: String
  , docMetaTitle  :: String
  , docMetaPath   :: FilePath
  } deriving (Show)

data DocSource = File FilePath |
                 Body Text |
                 Doc Pandoc

-- The node type
data DocNode = DocNode DocMeta DocSource

instance Eq DocNode where
  (==) (DocNode m1 _) (DocNode m2 _) =
    (docMetaPath m1) == (docMetaPath m2)

instance Ord DocNode where
  compare (DocNode m1 _) (DocNode m2 _) =
    compare (docMetaPath m1) (docMetaPath m2)

instance Show DocNode where
  show (DocNode m1 _) = docMetaPath m1

-- A standalone edge, for building graphs
type DocEdge = (String, DocNode, DocNode)

-- A labelled graph of nodes, which captures a body of documentation.
type DocGraph = AdjacencyMap String DocNode
