module Treedoc.Writers
  ( TreedocWriter (..)
  , getTreeWriter
  , writeFromTree_GM
  , writeFromTree_TI ) where

import qualified Text.Pandoc.App as P

import Text.Pandoc.Options (WriterOptions)

import Treedoc.Formats.GenericMarkup (writeFromTree_GM)
import Treedoc.Formats.Texinfo (writeFromTree_TI)
import Treedoc.Formats.Screen (writeFromTree_SC)
import Treedoc.Definition

import Data.Tree

data TreedocWriter = TreeWriter (WriterOptions -> DocTree -> FilePath -> IO ())

-- | Association list of tree formats and readers.
treedocWriters :: [(TreeFormat, TreedocWriter)]
treedocWriters = [(GenericMarkup, TreeWriter writeFromTree_GM)
                 ,(Texinfo,       TreeWriter writeFromTree_TI)]

getTreeWriter :: TreeFormat -> TreedocWriter
getTreeWriter format = case lookup format treedocWriters of
  Nothing -> TreeWriter writeFromTree_SC
  Just w -> w
