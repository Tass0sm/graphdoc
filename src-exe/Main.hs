module Main where

import Graphdoc.Analysis
import Graphdoc.Conversion
import Graphdoc.Output

import Control.Monad
import System.Environment
import Algebra.Graph.Export.Dot
import Algebra.Graph.Labelled.AdjacencyMap

-- analyzeMain :: [String] -> IO ()
-- analyzeMain args = do
--   opt <- A.parseOptionsFromArgs args
--   A.runAnalysis opt
-- 
-- convertMain :: [String] -> IO ()
-- convertMain args = undefined

main :: IO ()
main = do
  arg <- head <$> getArgs
  graph <- analyzeHTML arg
  putStrLn "Finished Analysis"
  let newGraph = convertToTexinfo graph
  putStrLn "Finished Conversion"
  outputTexinfo "./out.texi" newGraph
  putStrLn "Finished Output"

--   putStrLn $ exportAsIs sGraph

--  (subcommand:args) <- getArgs
--  case subcommand of
--    "analyze" -> analyzeMain args
--    "convert" -> convertMain args
--    otherwise -> putStrLn "Bad Sub-command."
