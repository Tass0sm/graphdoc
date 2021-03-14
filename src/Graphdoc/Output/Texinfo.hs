{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Output.Texinfo
  ( outputTexinfo ) where

import Graphdoc.Definition
import Graphdoc.Output.Util

import Text.Pandoc
import Text.Pandoc.Class
import Text.Pandoc.Writers
import Text.Pandoc.Builder

import System.IO
import System.FilePath
import Data.Maybe
import Data.Either
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Map as Map

import Algebra.Graph.Export.Dot
import Algebra.Graph.Labelled.AdjacencyMap
import Algebra.Graph.AdjacencyMap.Algorithm
import qualified Algebra.Graph.AdjacencyMap as Unlabelled

findVertexWithBaseName :: String -> DocGraph -> String
findVertexWithBaseName path (_, docGraph) =
  let vertices = vertexList docGraph
  -- UNSAFE!!!
  in head $ filter hasTheBaseName vertices
  where hasTheBaseName = (path ==) . takeBaseName

simplifiedGraph :: DocGraph -> Unlabelled.AdjacencyMap FilePath
simplifiedGraph (_, docGraph) =
  let isTopEdge = ("TOP" == ) . (\(s, _, _) -> s)
      labelledTopEdges = filter isTopEdge $ edgeList docGraph
      unlabelledTopEdges = map (\(_, a, b) -> (b, a)) labelledTopEdges
  in Unlabelled.edges unlabelledTopEdges

flattenGraph :: DocGraph -> [(Int, FilePath)]
flattenGraph graph =
  let rootNode = findVertexWithBaseName "index" graph
      simpleGraph = simplifiedGraph graph
  in dfsWithDepth [rootNode] simpleGraph 

writer :: Writer PandocPure
writer = fromJust $ lookup "texinfo" writers

makeConverter :: Writer PandocPure -> (Pandoc -> T.Text)
makeConverter (TextWriter w) = textOrDefault . runPure . w def
  where textOrDefault = fromRight "Failure"

simpleConverter :: Pandoc -> T.Text
simpleConverter = makeConverter writer

outputTexinfo :: String -> DocGraph -> IO ()
outputTexinfo destination graph@(docMap, _) =
  let nodeList = flattenGraph graph
      getDocWithDepth = \(d, f) -> (d, fromJust $ Map.lookup f docMap) -- Replace with lenses?
      docWithDepthList = map getDocWithDepth nodeList
      prependHeader = \(d, (Doc (Pandoc m bs))) ->
        let documentHeader = header d $ fromList $ docTitle m
            existingBlocks = fromList bs
            wholeBlocks = toList $ documentHeader <> existingBlocks
        in Pandoc m wholeBlocks
      docList = map prependHeader docWithDepthList
      totalDoc = mconcat docList
      docText = simpleConverter totalDoc
  in withFile destination WriteMode
     (\h -> TIO.hPutStr h docText)




