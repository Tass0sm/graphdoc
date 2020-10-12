module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , writeFromTree_GM ) where

import qualified Data.Text as T
import Data.Tree
import System.Directory

import Treedoc.Definition
import Treedoc.Util

-- Pure Code:


-- Impure Code:

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = do
  contents <- saferReadFile path
  subFiles <- saferListDirectory path
  let name = getFileName path in
    return ((name, contents), subFiles)

readIntoTree_GM :: FilePath -> IO (DocTree)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

writeFromTree_GM :: FilePath -> DocTree -> IO ()
writeFromTree_GM path (Node node children) =
  let newPath = (path ++ "/" ++ (fst node)) in
    if null children
    then writeFile newPath (T.unpack $ snd node)
    else do
      createDirectoryIfMissing True newPath
      mconcat $ map (writeFromTree_GM newPath) children
