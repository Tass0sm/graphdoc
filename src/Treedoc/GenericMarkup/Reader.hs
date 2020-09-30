-- Things for reading a directory of generic markup files into a documentation tree.

module Treedoc.GenericMarkup.Reader
  ( readIntoTree ) where

import qualified Data.Text as T
import qualified Data.Tree as Tree
import Treedoc.Definition
import Treedoc.Util

-- Pure Code:

-- Impure Code:

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  contents <- saferReadFile path
  subFiles <- saferListDirectory path
  let name = getFileName path in
    return ((name, contents), subFiles)

readIntoTree :: FilePath -> IO (DocTree)
readIntoTree path = (Tree.unfoldTreeM_BF unfolder) path
