{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Texinfo
  ( convertToTexinfo ) where

import Data.Maybe

import Graphdoc.Definition
import Graphdoc.Conversion.Util

import Text.Pandoc
import System.FilePath

-- Will switch to lenses
convertMetadata :: DocMeta -> DocMeta
convertMetadata m@(DocMeta _ _ p _) =
  m
  { docMetaFormat = "texinfo"
  , docMetaPath = p -<.> "texi"
  }

-- TODO
convertPandoc :: Pandoc -> Pandoc
convertPandoc = id

convertToTexinfo :: DocGraph -> DocGraph
convertToTexinfo g = 
  let nodeConverter = liftConverter convertMetadata convertPandoc
  in mapDocGraph nodeConverter g
