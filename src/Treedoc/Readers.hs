module Treedoc.Readers
  ( getTreeReader
  , readIntoTree_GM
  , readIntoTree_TI ) where

import Data.Tree

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (readIntoTree_GM)
import Treedoc.Formats.Texinfo (readIntoTree_TI)

getTreeReader :: Format -> FilePath -> IO (Tree DocNode)
getTreeReader format = case format of
  GenericMarkup -> readIntoTree_GM
  Texinfo -> readIntoTree_TI
