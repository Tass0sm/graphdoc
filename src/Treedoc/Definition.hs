module Treedoc.Definition
  ( TextTree
  , TreeReader
  , TreeWriter ) where

import Data.Text
import Data.Tree

type TextTree   = Tree Text
type TreeReader = FilePath -> IO (TextTree)
type TreeWriter = TextTree -> IO ()
