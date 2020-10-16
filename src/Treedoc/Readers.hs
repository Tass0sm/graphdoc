module Treedoc.Readers
  ( getTreeReader ) where

import Data.Tree

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup

getTreeReader :: Format -> FilePath -> IO (Tree DocSource)
getTreeReader format = case format of
  GenericMarkup -> readIntoTree_GM
  _ -> undefined
