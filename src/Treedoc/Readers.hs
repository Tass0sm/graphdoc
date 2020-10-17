module Treedoc.Readers
  ( getTreeReader
  , readIntoTree_GM ) where

import Data.Tree

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (readIntoTree_GM)

getTreeReader :: Format -> FilePath -> IO (Tree DocSource)
getTreeReader format = case format of
  GenericMarkup -> readIntoTree_GM
  _ -> undefined
