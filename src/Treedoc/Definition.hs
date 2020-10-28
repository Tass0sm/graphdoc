module Treedoc.Definition
  ( DocSource
  , Format(..) ) where

import System.IO (FilePath)
import Data.Text (Text)

type DocSource = (FilePath, Text)

data Format = GenericMarkup | Texinfo
  deriving (Show, Read)
