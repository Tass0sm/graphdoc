{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Conversion.Util
    ( liftConverter ) where

import qualified Data.Text.IO as TIO
import Data.Text
import Data.Either

import Graphdoc.Definition
import Text.Pandoc
import Algebra.Graph.Labelled.AdjacencyMap

-- Will switch to lenses
liftConverter :: (Pandoc -> Pandoc)
              -> (DocSource -> DocSource)
liftConverter contentF =
  \(Doc p) -> (Doc $ contentF p)
