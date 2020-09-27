module Treedoc.Util
  ( saferListDirectory
  , saferReadFile      ) where

import qualified Data.Text as T
import System.Directory
import System.IO

-- Pure Code:

-- Get name of file after final file seperator. If the file path is relative and
-- with no seperators, it is already the the name we are interested in.
getFileName :: FilePath -> String
getFileName path =
  let (prefix, suffix) = break (=='/') path in
    if null suffix
    then prefix
    else getFileName (tail suffix)

-- Impure Code:

listDirectoryAbsolute :: FilePath -> IO [FilePath]
listDirectoryAbsolute path = do
    absPath <- makeAbsolute path
    files <- listDirectory absPath
    let absFiles = map ((absPath ++ "/")++) files
      in return absFiles

saferListDirectory :: FilePath -> IO [FilePath]
saferListDirectory path =
  doesDirectoryExist path >>= (\x ->
     case x of
       True  -> listDirectoryAbsolute path
       False -> return [] )

saferReadFile :: FilePath -> IO (T.Text)
saferReadFile path =
  doesFileExist path >>= (\x ->
     case x of
       True  -> T.pack `fmap` (readFile path)
       False -> return $ T.pack $ getFileName path )
