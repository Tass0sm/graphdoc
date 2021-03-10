{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Texinfo
  ( convertToTexinfo ) where

import Data.Maybe

import Graphdoc.Definition
import Graphdoc.Conversion.Util

import Text.Pandoc
import Text.Pandoc.Walk
import System.FilePath

-- Will switch to lenses
convertMetadata :: DocMeta -> DocMeta
convertMetadata m@(DocMeta _ p _) =
  m
  { docMetaFormat = "texinfo"
  , docMetaPath = p -<.> "texi"
  }

convertPandoc :: Pandoc -> Pandoc
convertPandoc = walk removeHeader
  where removeHeader :: Block -> Block
        removeHeader (Header _ _ ils) = Para ils
        removeHeader x = x

convertToTexinfo :: DocGraph -> DocGraph
convertToTexinfo g = 
  let nodeConverter = liftConverter convertMetadata convertPandoc
  in mapDocGraph nodeConverter g
