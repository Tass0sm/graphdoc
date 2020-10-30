module Treedoc.Util
  ( translatePath
  , saferListDirectory
  , saferReadFile
  , convertFileWithOpts
  , convertTextWithOpts ) where

import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import System.Directory
import System.IO
import System.FilePath
import System.IO.Temp

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
    let absFiles = map (absPath</>) files
    return absFiles

saferListDirectory :: FilePath -> IO [FilePath]
saferListDirectory path =
  doesDirectoryExist path >>= (\x ->
                                  case x of
                                    True  -> listDirectoryAbsolute path
                                    False -> return [] )

convertFileWithOpts :: FilePath -> FilePath -> P.Opt -> IO ()
convertFileWithOpts input output opt = P.convertWithOpts $ opt { P.optInputFiles = Just [input]
                                                               , P.optOutputFile = Just output }

convertTextWithOpts :: T.Text -> FilePath -> P.Opt -> IO ()
convertTextWithOpts text output opt = do
  tempInputPath <- writeSystemTempFile "input.txt" (T.unpack text)
  convertFileWithOpts tempInputPath output opt

saferReadFile :: FilePath -> IO (T.Text)
saferReadFile path =
  doesFileExist path >>= (\x ->
     case x of
       True  -> T.pack `fmap` (readFile path)
       False -> return T.empty )
