{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Util
    ( liftConverter
    , mapDocGraph ) where

import qualified Data.Text.IO as TIO
import Data.Text
import Data.Either

import Graphdoc.Definition
import Text.Pandoc
import Algebra.Graph.Labelled.AdjacencyMap

-- Will switch to lenses
liftConverter :: (DocMeta -> DocMeta)
              -> (Pandoc -> Pandoc)
              -> (DocNode -> DocNode)
liftConverter metaF contentF =
  \(DocNode m (Doc p)) -> DocNode (metaF m) (Doc $ contentF p)

mapDocGraph :: (DocNode -> DocNode) -> DocGraph -> DocGraph
mapDocGraph converter src = gmap converter src
  
  
