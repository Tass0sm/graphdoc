module Text.Graphdoc.Definition
  ( GraphSource
  , Graphdoc(..)
  , GraphdocNodeType(..)
  , GraphdocNode(..) ) where

import Data.Tree
import Data.Text (Text)
import System.FilePath
import System.Directory.Tree
import Text.Pandoc.Definition as P

type GraphSource = AnchoredDirTree Text

data Graphdoc = Graphdoc P.Meta (Tree GraphdocNode)
                deriving (Eq, Read, Show)

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
