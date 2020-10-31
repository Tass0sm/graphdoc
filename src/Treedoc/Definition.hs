module Treedoc.Definition
  ( DocNode
  , TreeFormat(..) ) where

import System.IO (FilePath)
import Data.Text (Text)

-- A node of documentation, consisting of the node's name, and node's format as
-- a possibly lowercase string (convention chosen by pandoc, not me), and its
-- contents. Like a subsection of a document. No format == Nothing
type DocNode = (String, Maybe String, Text)

data TreeFormat = GenericMarkup | Texinfo
  deriving (Show, Read)
