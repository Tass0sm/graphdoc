module Treedoc.Readers
  ( TreedocReader (..)
  , getTreeReader
  , readIntoTree_GM
  , readIntoTree_TI ) where

import Data.Tree

import Text.Pandoc

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (readIntoTree_GM)
import Treedoc.Formats.Texinfo (readIntoTree_TI)

data TreedocReader m = TreeReader (FilePath -> m DocTree)

-- | Association list of tree formats and readers.
treedocReaders :: [(TreeFormat, TreedocReader PandocIO)]
treedocReaders = [(GenericMarkup, TreeReader readIntoTree_GM)
                 ,(Texinfo,       TreeReader readIntoTree_TI)]

getTreeReader :: TreeFormat -> TreedocReader PandocIO
getTreeReader format = case lookup format treedocReaders of
  Nothing -> TreeReader readIntoTree_GM
  Just r -> r
