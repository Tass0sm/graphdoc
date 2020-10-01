-- Things for writing a documentation tree into a directory of generic markup files.

module Treedoc.GenericMarkup.Writer
  ( writeFromTree ) where

import qualified Data.Text as T
import Data.Tree
import Treedoc.Definition
import System.IO
import System.Directory

-- Pure Code:

-- Impure Code:

writeFromTree :: FilePath -> DocTree -> IO ()
writeFromTree path (Node node children) =
  let newPath = (path ++ "/" ++ (fst node)) in
    if null children
    then writeFile newPath (T.unpack $ snd node)
    else do
      createDirectoryIfMissing True newPath
      mconcat $ map (writeFromTree newPath) children
