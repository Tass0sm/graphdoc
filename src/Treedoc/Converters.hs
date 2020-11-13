module Treedoc.Converters
  ( getTreeConverter
  , convertTree_GM
  , convertTree_TI ) where

import qualified Text.Pandoc.App as P

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (convertTree_GM)
import Treedoc.Formats.Texinfo (convertTree_TI)
import Treedoc.Formats.Screen (convertTree_SC)

getTreeConverter :: Maybe TreeFormat -> P.Opt -> DocTree -> DocTree
getTreeConverter format = case format of
  Just GenericMarkup -> convertTree_GM
  Just Texinfo -> convertTree_TI
  Nothing -> convertTree_SC

