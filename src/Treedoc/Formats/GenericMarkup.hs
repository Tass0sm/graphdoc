module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , writeFromTree_GM ) where

import qualified Text.Pandoc.App as P

import qualified Data.Text as T
import Data.Tree
import System.Directory

import Treedoc.Definition
import Treedoc.Util

-- Impure Code:

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  subFiles <- saferListDirectory path
  let name = getFileName path
  return (name, subFiles)

readIntoTree_GM :: FilePath -> IO (Tree DocSource)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

writeFromTree_GM :: FilePath -> FilePath -> Tree DocSource -> P.Opt -> IO ()
writeFromTree_GM outputPath prefixPath (Node node children) opt =
  let source = prefixPath ++ "/" ++ node
      output = outputPath ++ "/" ++ node
  in
    if null children
    then do
      convertFileWithOpts source output opt
    else do
      createDirectoryIfMissing True output
      mconcat $ map (\tree -> writeFromTree_GM output source tree opt) children
