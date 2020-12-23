module Treedoc.Converters
  ( Converter (..)
  , getTreeConverter
  , convertTree_GM
  , convertTree_TI ) where

import qualified Text.Pandoc.App as P

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (convertTree_GM)
import Treedoc.Formats.Texinfo (convertTree_TI)
import Treedoc.Formats.Screen (convertTree_SC)

data Converter = TreeConverter (P.Opt -> DocTree -> DocTree)

-- | Association list of tree formats and converters.
treedocConverters :: [(TreeFormat, Converter)]
treedocConverters = [(GenericMarkup, TreeConverter convertTree_GM)
                    ,(Texinfo,       TreeConverter convertTree_TI)
                    ,(Screen,       TreeConverter convertTree_SC)]

getTreeConverter :: TreeFormat -> Converter
getTreeConverter format = case lookup format treedocConverters of
  Nothing -> TreeConverter convertTree_SC
  Just c -> c
