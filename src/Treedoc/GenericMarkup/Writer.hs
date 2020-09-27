-- Things for writing a documentation tree into a directory of generic markup files.

module Treedoc.GenericMarkup.Writer
  ( writeFromTree ) where

import Treedoc.Definition

-- Pure Code:

-- Impure Code:

writeFromTree :: TreeWriter
writeFromTree tree dest = do
  createDirectoryIfMissing true dest
