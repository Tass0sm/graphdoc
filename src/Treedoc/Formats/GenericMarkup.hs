module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , writeFromTree_GM ) where

import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Data.Foldable (fold)
import Data.Tree

import System.Directory
import System.FilePath

import Treedoc.Definition
import Treedoc.Util

-- Impure Code:
--- Reading:

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  docSource <- getDocSource path
  subFiles <- saferListDirectory path
  return (docSource, subFiles)

readIntoTree_GM :: FilePath -> IO (Tree DocSource)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: DocSource -> FilePath -> P.Opt -> IO ()
convertLeaf input output opt =
  let inputFile = fst input
  in convertFileWithOpts inputFile output opt

convertInner :: FilePath -> IO ()
convertInner output = createDirectoryIfMissing True output
  
convertNode :: DocSource -> FilePath -> FilePath -> Bool -> P.Opt -> IO ()
convertNode input root output isLeaf opt =
  if isLeaf
  then convertLeaf input absoluteOutput opt
  else convertInner absoluteOutput
  where
    inputLocation = fst input
    absoluteOutput = translatePath root inputLocation output
  
writeFromTree_GM :: FilePath -> Tree DocSource -> P.Opt -> IO ()
writeFromTree_GM output tree@(Node rootSource _) opt =
  let root = fst rootSource
      converter = (\isLeaf input -> convertNode input root output isLeaf opt)
  in fold $ mapTreeWithLeafCondition converter tree
