module Graphdoc.Definition
  ( DocGraph
  , DocSource (..)
  , DocNode (..)
  , DocEdge
  , DocMeta (..) ) where

import Algebra.Graph.Labelled.AdjacencyMap
import Text.Pandoc.Definition
import Data.Text (Text)
import Data.Map

-- All the information for a node in the graph (metadata and source).
data DocMeta = DocMeta
  { docMetaFormat :: String
  , docMetaPath   :: FilePath
  , docMetaIsTop  :: Bool
  } deriving (Show)

instance Eq DocMeta where
  (==) (DocMeta _ p1 _) (DocMeta _ p2 _) =
    p1 == p2

instance Ord DocMeta where
  compare (DocMeta _ p1 _) (DocMeta _ p2 _) =
    compare p1 p2

type DocNode = DocMeta

-- A standalone edge, for building graphs
type DocEdge = (String, DocNode, DocNode)

data DocSource = Body Text |
                 Doc Pandoc

-- A labelled graph of nodes, which captures a body of documentation.
type DocGraph = (Map FilePath DocSource, AdjacencyMap String FilePath)
