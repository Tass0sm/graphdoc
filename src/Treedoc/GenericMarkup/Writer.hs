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
  -- Check the base case:
  if null children
  then
    -- Step 1. Write the text to a file at the given location (path), and with the
    -- name of the original file.
    writeFile (path ++ "/" ++ (fst node)) (T.unpack $ snd node)
  else
    let newPath = (path ++ "/" ++ (fst node)) in
      do
        -- Step 1, Write the root node,
        createDirectoryIfMissing True newPath
        -- Step 2, Recurse over the child nodes, and concat resulting list of IO
        -- operations into one IO operation.
        mconcat $ map (writeFromTree newPath) children
