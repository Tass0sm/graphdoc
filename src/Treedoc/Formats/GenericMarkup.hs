module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , writeFromTree_GM ) where

import qualified Text.Pandoc.App as P

import qualified Data.Text as T
import Data.Tree
import System.Directory
import System.FilePath

import Treedoc.Definition
import Treedoc.Util

-- Impure Code:

convertFileWithOpts :: FilePath -> FilePath -> P.Opt -> IO ()
convertFileWithOpts input output opt = P.convertWithOpts $ opt { P.optInputFiles = Just [input]
                                                               , P.optOutputFile = Just output }

--- Reading:

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  name <- makeAbsolute path
  subFiles <- saferListDirectory path
  return (name, subFiles)

readIntoTree_GM :: FilePath -> IO (Tree DocSource)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: FilePath -> FilePath -> P.Opt -> IO ()
convertLeaf source output opt = convertFileWithOpts source output opt

convertInner :: FilePath -> IO ()
convertInner output = createDirectoryIfMissing True output
  
convertNode :: FilePath -> FilePath -> FilePath -> Bool -> P.Opt -> IO ()
convertNode root input output isLeaf opt =
  if isLeaf
  then convertLeaf input absoluteOutput opt
  else convertInner absoluteOutput
  where
    absoluteOutput = translatePath root input output
  
writeFromTree_GM :: FilePath -> Tree DocSource -> P.Opt -> IO ()
writeFromTree_GM output tree@(Node root children) opt =
  let converter = (\isLeaf input -> convertNode root input output isLeaf opt)
  in mconcat $ flatten (mapTreeWithLeafCondition converter tree)
