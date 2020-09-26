module TreeReaders.Alphabetical (
                                 ) where

import Data.List
import DocTree

getIndexAlphabetical :: FilePath -> [FilePath] -> TreeIndex

getChildrenAlphabetical :: FilePath -> [FilePath] -> [FilePath]
getChildrenAlphabetical file allFiles =
  let fileIndex = getIndexAlphabetical file
  in filter (\x -> isIndexInChildren fileIndex
                   getIndexAlphabetical x) allFiles


makeDocTreeAlphabetical :: FilePath -> DocTree
