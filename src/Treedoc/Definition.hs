module Treedoc.Definition
  ( DocSource
  , Format(..) ) where

-- import Data.Text
-- import Data.Tree

import System.IO (FilePath)

-- Pure Code:

type DocSource = FilePath
-- type DocTree = Tree DocSource

data Format = GenericMarkup | Texinfo
  deriving (Show, Read)

-- Impure Code:
