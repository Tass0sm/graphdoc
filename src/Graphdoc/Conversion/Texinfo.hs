{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Texinfo
  ( convertToTexinfo ) where

import Data.Maybe

import Graphdoc.Definition
import Graphdoc.Conversion.Util

import System.FilePath
import Text.Pandoc.Class
import Text.Pandoc.Writers

writer :: Writer PandocPure
writer = fromJust $ lookup "texinfo" writers

-- Will switch to lenses
convertMetadata :: DocMeta -> DocMeta
convertMetadata m@(DocMeta _ _ p _) =
  m
  { docMetaFormat = "texinfo"
  , docMetaPath = p -<.> "texi"
  }

convertToTexinfo :: DocGraph -> DocGraph
convertToTexinfo g = 
  let converter = makeConverter writer
      nodeConverter = liftConverter convertMetadata converter
  in mapDocGraph nodeConverter g
