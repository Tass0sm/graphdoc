module Treedoc.Converters
  ( getTreeConverter
  , convertTree_GM ) where

import qualified Text.Pandoc.App as P

import Treedoc.Definition
import Treedoc.Formats.GenericMarkup (convertTree_GM)

getTreeConverter :: TreeFormat -> P.Opt -> DocTree -> IO DocTree
getTreeConverter format = case format of
  GenericMarkup -> convertTree_GM

