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
import Data.Maybe
import Data.Either
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Algebra.Graph.Export.Dot
import Algebra.Graph.Labelled.AdjacencyMap
import Algebra.Graph.AdjacencyMap.Algorithm
import qualified Algebra.Graph.AdjacencyMap as Unlabelled

findVertexWithPath :: String -> DocGraph -> DocNode
findVertexWithPath path graph =
  let vertices = vertexList graph
  -- UNSAFE!!!
  in head $ filter hasThePath vertices
  where hasThePath = (path ==) . show

simplifyGraph :: DocGraph -> Unlabelled.AdjacencyMap DocNode
simplifyGraph graph =
  let isTopEdge = ("TOP" == ) . (\(s, _, _) -> s)
      labelledTopEdges = filter isTopEdge $ edgeList graph
      unlabelledTopEdges = map (\(_, a, b) -> (b, a)) labelledTopEdges
  in Unlabelled.edges unlabelledTopEdges

flattenGraph :: DocGraph -> [(Int, DocNode)]
flattenGraph graph =
  let rootNode = findVertexWithPath "/home/tassos/desktop/sample-doc/FrontMatter/index.texi" graph
      simplifiedGraph = simplifyGraph graph
  in dfsWithDepth [rootNode] simplifiedGraph 

writer :: Writer PandocPure
writer = fromJust $ lookup "texinfo" writers

makeConverter :: Writer PandocPure -> (Pandoc -> T.Text)
makeConverter (TextWriter w) = textOrDefault . runPure . w def
  where textOrDefault = fromRight "Failure"

simpleConverter :: Pandoc -> T.Text
simpleConverter = makeConverter writer

outputTexinfo :: String -> DocGraph -> IO ()
outputTexinfo destination graph =
  let nodeList = flattenGraph graph
      getDocWithDepth = \(d, (DocNode _ (Doc p))) -> (d, p) -- Replace with lenses?
      docWithDepthList = map getDocWithDepth nodeList
      prependHeader = \(d, Pandoc m bs) ->
        let documentHeader = header d $ fromList $ docTitle m
            existingBlocks = fromList bs
            wholeBlocks = toList $ documentHeader <> existingBlocks
        in Pandoc m wholeBlocks
      docList = map prependHeader docWithDepthList
      totalDoc = mconcat docList
      docText = simpleConverter totalDoc
  in do
    putStrLn $ show nodeList
    putStrLn $ show totalDoc
    withFile destination WriteMode
      (\h -> TIO.hPutStr h docText)




