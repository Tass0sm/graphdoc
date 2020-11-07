module Treedoc.Writers
  ( getTreeWriter
  , writeFromTree_GM
  , writeFromTree_TI ) where

import qualified Text.Pandoc.App as P

import Treedoc.Formats.GenericMarkup (writeFromTree_GM)
import Treedoc.Formats.Texinfo (writeFromTree_TI)
import Treedoc.Formats.Screen (writeFromTree_SC)
import Treedoc.Definition

import Data.Tree

getTreeWriter :: Maybe TreeFormat -> DocTree -> FilePath -> IO ()
getTreeWriter format = case format of
  Just GenericMarkup -> writeFromTree_GM
  Just Texinfo -> writeFromTree_TI
  Nothing -> writeFromTree_SC
