module DocTree
  ( DocTree (..)
  ) where

import qualified Data.Text as T
import Text.Pandoc
import Data.List
import Data.Tree
import System.Directory

getAllSources :: FilePath -> IO [FilePath]
getAllSources dir = listDirectory dir

-- A Tree of Documentation Text.
type DocTree = Tree T.Text
type TreeIndex = [Int]

isChildOf :: TreeIndex -> TreeIndex -> Bool
isChildOf child parent = parent `isPrefixOf` child && (lenC - lenP) = 1
  where lenC = length child
        lenP = length parent

{-
The process of building a doc tree uses the unfoldTree function.

unfoldTree :: (b -> (a, [b])) -> b -> Tree a

It takes a function, which maps from some seed type to a tuple of the tree's
main type and a list of values of the seed type. The current approach for a doc
tree is as follows:

b (the seed value type) = FilePath
a (the tree type) = Text

The unfolding function = (FilePath -> (Text, [FilePath]))

This function takes a FilePath to a documentation source file. It returns a
tuple containing the text for that documentation, and list of other files (in
order) for which the original file is a parent. In the context of TexInfo files,
every child node's up pointer goes to the parent, the next pointer goes to the
next child in the list, and the prev pointer goes the previous child in the
list.
-}

x = Node "Two" [ Node "One" [], Node "Three" [] ]

{-
-- Takes the path to a documentation source, reads it, and returns a list of
-- files that are children of the original file. Like sections of a chapter.
getChildrenSources :: FilePath -> IO [FilePath]

readDirectoryIntoTree :: FilePath -> DocTree
-}
