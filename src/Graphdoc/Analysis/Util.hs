module Graphdoc.Analysis.Util
  ( listDirectoryRecursively
  , getSourceFiles
  , Predicate ) where

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

type Predicate = FilePath -> Bool

getSourceFiles :: Predicate -> FilePath -> IO [FilePath]
getSourceFiles p topPath = do
  files <- listDirectoryRecursively topPath
  -- TODO: This can later be made with filterM for better predicates. Skipping
  -- for now.
  return $ filter p files
