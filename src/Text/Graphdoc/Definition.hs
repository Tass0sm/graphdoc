module Text.Graphdoc.Definition
  ( GraphSource
  , Graphdoc(..)
  , GraphdocEdge(..)
  , GraphdocNodeType(..)
  , GraphdocNode(..) ) where

import Data.Tree
import Data.Text (Text)
import Data.Graph.Inductive
import System.FilePath
import System.Directory.Tree
import Text.Pandoc.Definition as P

type GraphSource = AnchoredDirTree Text

data Graphdoc = Graphdoc P.Meta (Gr GraphdocNode GraphdocEdge)
  deriving (Eq, Read, Show)

data GraphdocEdge = Up | Fwd | Prev | Top | Other String | Reverse GraphdocEdge
  deriving (Eq, Ord, Read, Show)

data GraphdocNodeType = Title Text
                      | PartTitle Text
                      | Chapter Int Text
                      | Separator
                      deriving (Eq, Read, Show)

data GraphdocNode = GraphdocNode
  { nodeType :: GraphdocNodeType
  , nodeContent :: P.Pandoc
  , nodeURL :: Text
  } deriving (Eq, Read, Show)
