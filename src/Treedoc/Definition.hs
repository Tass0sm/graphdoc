module Treedoc.Definition
  ( DocSource
  , Format(..) ) where

import System.IO (FilePath)

type DocSource = FilePath

data Format = GenericMarkup | Texinfo
  deriving (Show, Read)
