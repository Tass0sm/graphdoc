module Graphdoc.Output.Texinfo
  ( outputTexinfo ) where

import Graphdoc.Definition

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

-- depth first traversal 

simplifyGraph :: DocGraph -> Unlabelled.AdjacencyMap DocNode
simplifyGraph graph =
  let isTopEdge = ("TOP" == ) . (\(s, _, _) -> s)
      labelledTopEdges = filter isTopEdge $ edgeList graph
      unlabelledTopEdges = map (\(_, a, b) -> (b, a)) labelledTopEdges
  in Unlabelled.edges unlabelledTopEdges

flattenGraph :: DocGraph -> [DocNode]
flattenGraph graph =
  let rootNode = findVertexWithPath "/home/tassos/desktop/sample-doc/FrontMatter/index.texi" graph
      simplifiedGraph = simplifyGraph graph
  in dfs [rootNode] simplifiedGraph 

outputTexinfo :: DocGraph -> IO ()
outputTexinfo graph =
  let nodeList = flattenGraph graph
  in putStrLn $ show nodeList

--  let sGraph = Unlabelled.gmap show $ simplifyGraph graph
--  in putStrLn $ exportAsIs sGraph

-- putStrLn $ exportAsIs sGraph
