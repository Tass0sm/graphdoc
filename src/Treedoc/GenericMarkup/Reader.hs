-- Things for reading a directory of generic markup files into a documentation tree.

module Treedoc.GenericMarkup.Reader
  ( readIntoTree ) where

import qualified Data.Text as T
import qualified Data.Tree as Tree
import Treedoc.Util
import Treedoc.Definition

-- Pure Code:

-- Impure Code:

unfolder :: Unfolder
unfolder path = do
  contents <- saferReadFile path
  subFiles <- saferListDirectory path
  return (contents, subFiles)

readIntoTree :: TreeReader
readIntoTree path = (Tree.unfoldTreeM_BF unfolder) path
