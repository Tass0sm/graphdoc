module Treedoc.Util
  ( saferListDirectory
  , translatePath ) where

import qualified Text.Pandoc.App as P
import System.Directory
import System.IO
import System.FilePath

import Treedoc.Definition

-- Pure Code:

translatePath :: FilePath -> FilePath -> FilePath -> FilePath
translatePath root absoluteSource output =
  normalise (output </> makeRelative root absoluteSource)

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
 
-- saferReadFile :: FilePath -> IO (T.Text)
-- saferReadFile path =
--   doesFileExist path >>= (\x ->
--      case x of
--        True  -> T.pack `fmap` (readFile path)
--        False -> return $ T.pack $ getFileName path )
-- 
