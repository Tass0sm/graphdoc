module Graphdoc.Util
  ( listDirectoryRecursively ) where

import Control.Monad

import System.FilePath
import System.Directory

listDirectoryRecursively :: FilePath -> IO [FilePath]
listDirectoryRecursively topPath = do
  isDir <- doesDirectoryExist topPath
  if isDir
    then do
    names <- listDirectory topPath
    let paths = map (topPath</>) names
    concat <$> forM paths listDirectoryRecursively
    else do
    return [topPath]
