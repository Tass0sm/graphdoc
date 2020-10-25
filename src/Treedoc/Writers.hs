module Treedoc.Writers
  ( getTreeWriter
  , writeFromTree_GM
  , writeFromTree_TI ) where

import qualified Text.Pandoc.App as P

import Treedoc.Formats.GenericMarkup (writeFromTree_GM)
import Treedoc.Formats.Texinfo (writeFromTree_TI)
import Treedoc.Definition

import Data.Tree

getTreeWriter :: Format -> FilePath -> Tree DocSource -> P.Opt -> IO ()
getTreeWriter format = case format of
  GenericMarkup -> writeFromTree_GM
  Texinfo -> writeFromTree_TI
