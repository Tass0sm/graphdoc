module Treedoc.Definition
  ( TextTree
  , Unfolder
  , TreeReader
  , TreeWriter ) where

import Data.Text
import Data.Tree
import System.Directory

type TextTree   = Tree Text

-- Pure Code:

-- Impure Code:

type Unfolder   = FilePath -> IO (Text, [FilePath])
type TreeReader = FilePath -> IO (TextTree)
type TreeWriter = TextTree -> FilePath -> IO ()
