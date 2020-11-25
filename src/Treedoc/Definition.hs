module Treedoc.Definition
  ( TreeFormat(..)
  , DocNode
  , DocTree ) where

import Text.Pandoc.Definition (Pandoc)
import System.IO (FilePath)
import Data.Text (Text)
import Data.Tree (Tree)

-- The types of tree recognized by treedoc.
data TreeFormat = GenericMarkup | Texinfo | Screen
  deriving (Show, Read, Eq)

-- A node of documentation, consisting of the node's name, and node's format as
-- a possibly lowercase string (convention chosen by pandoc, not me), and its
-- contents. Like a subsection of a document. No format == Nothing
type DocNode = (String, Maybe Text, Pandoc)

-- A Documentation Tree, consisting of a format and tree of documentation nodes.
type DocTree = (TreeFormat, Tree DocNode)
