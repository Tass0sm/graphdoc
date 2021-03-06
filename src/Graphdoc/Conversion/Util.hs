{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Util
    ( makeConverter
    , liftConverter
    , mapDocGraph ) where

import qualified Data.Text.IO as TIO
import Data.Text
import Data.Either

import Graphdoc.Definition
import Text.Pandoc
import Algebra.Graph.Labelled.AdjacencyMap

makeConverter :: Writer PandocPure -> (Pandoc -> Text)
makeConverter (TextWriter w) = textOrDefault . runPure . w def
  where textOrDefault = fromRight "Failure"

-- Will switch to lenses
liftConverter :: (DocMeta -> DocMeta)
              -> (Pandoc -> Text)
              -> (DocNode -> DocNode)
liftConverter metaF contentF =
  \(DocNode m (Doc p))
  -> DocNode (metaF m) (Body $ contentF p)

mapDocGraph :: (DocNode -> DocNode) -> DocGraph -> DocGraph
mapDocGraph converter src = gmap converter src
  
  
