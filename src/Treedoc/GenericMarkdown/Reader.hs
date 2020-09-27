-- Things for reading a directory of generic markdown files into a documentation tree.

module Treedoc.GenericMarkdown.Reader
  ( readIntoTree ) where

import qualified Data.Text as T
import System.Directory
import System.IO
import Treedoc.Definition

-- Pure Code:

unfolder :: FilePath -> (T.Text, [FilePath])
unfolder path = do
  subFiles <- saferListDirectory path

  | doesDirectoryExist file = do
      subFiles <- listDirectory file
      (T.empty, subFiles)
  | otherwise = do
      content <- readFile file
      (content, [])

-- Impure Code:

readIntoTree :: TreeReader
readIntoTree path = unfoldTree $ unfolder path
