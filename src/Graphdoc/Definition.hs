module Graphdoc.Definition
  ( DocGraph
  , DocSource (..)
  , DocNode (..)
  , DocEdge
  , DocMeta (..)
  , Reader
  , Converter
  , Writer) where

import Text.Pandoc.Definition
import Data.Text (Text)
import Data.Tree (Tree)

data DocMeta = DocMeta
  { docMetaId     :: Integer
  , docMetaFormat :: String
  , docMetaPath   :: FilePath
  , docMetaIsTop  :: Bool
  } deriving (Show)

data DocSource = Body Text | Doc Pandoc

data DocEdge = DocEdge
  { docEdgeLabel  :: String
  , docEdgeTarget :: Integer
  }

data DocNode = DocNode
  { docNodeInfo      :: DocMeta
  , docNodeSource    :: DocSource
  , docNodeOutEdges  :: [DocEdge]
  }

-- A tree of nodes, which also have associated edges.
type DocGraph = Tree DocNode

type Reader = FilePath -> IO DocGraph
type Converter = DocGraph -> DocGraph
type Writer = DocGraph -> IO ()
