module Treedoc.Definition
  ( TextTree
  , Unfolder
  , TreeReader
  , TreeWriter ) where

import Data.Text
import Data.Tree
import System.Directory

type TextTree   = Tree Text

-- Pure Functions:

type Unfolder   = FilePath -> IO (Text, [FilePath])

-- Impure Functions:

type TreeReader = FilePath -> IO (TextTree)
type TreeWriter = TextTree -> IO ()
