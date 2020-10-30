module Treedoc.Definition
  ( DocNode
  , Format(..) ) where

import System.IO (FilePath)
import Data.Text (Text)

-- A node of documentation, consisting of the node's name, and its
-- contents. Like a subsection of a document.
type DocNode = (String, Text)

data Format = GenericMarkup | Texinfo
  deriving (Show, Read)
