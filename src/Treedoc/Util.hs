module Treedoc.Util
  ( saferListDirectory ) where

import qualified Data.Text as T
import System.Directory
import System.IO

saferListDirectory :: FilePath -> IO [FilePath]
saferListDirectory path =
  doesDirectoryExist path >>= (\x ->
     case x of
       True  -> listDirectory path
       False -> return [] )

saferGetContents :: FilePath -> IO (T.Text)
saferGetContents path =
  doesFileExist path >>= (\x ->
     case x of
       True  -> T.pack `fmap` (readFile path)
       False -> return T.empty )
