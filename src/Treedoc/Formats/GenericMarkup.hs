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

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  name <- makeAbsolute path
  subFiles <- saferListDirectory path
  return (name, subFiles)

readIntoTree_GM :: FilePath -> IO (Tree DocSource)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

convertLeaf :: FilePath -> DocSource -> FilePath -> P.Opt -> IO ()
convertLeaf root source output opt = do
  let relativeSource = makeRelative root source
  let absoluteOutput = output ++ relativeSource
  convertFileWithOpts source absoluteOutput opt
  

test_GM :: FilePath -> Tree DocSource -> P.Opt -> IO ()
test_GM outputPath tree@(Node source _) opt = undefined
  -- let root = source
  --foldMap (\node -> convertNode root node outputPath opt) tree


myTraverse :: FilePath -> FilePath -> Tree DocSource -> P.Opt -> IO ()
myTraverse output root (Node source children) opt =
  let absoluteOutput = translatePath root source output
   in if null children
     then do
    convertFileWithOpts source absoluteOutput opt
     else do
    createDirectoryIfMissing True absoluteOutput
    mconcat $ map (\tree -> myTraverse output root tree opt) children

writeFromTree_GM :: FilePath -> Tree DocSource -> P.Opt -> IO ()
writeFromTree_GM outputPath tree@(Node source children) opt =
  let root = source
  in myTraverse outputPath root tree opt
