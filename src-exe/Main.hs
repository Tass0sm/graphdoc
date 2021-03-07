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
  let newGraph = convertToTexinfo graph
  outputTexinfo "./out.texi" newGraph
  --let sGraph = gmap show newGraph
  --putStrLn $ exportAsIs sGraph

  --putStrLn $ exportAsIs graph
  --mapM_ (putStrLn . show) pairs

--  files <- listDirectoryRecursively "./src"
--  mapM_ putStrLn files

--  (subcommand:args) <- getArgs
--  case subcommand of
--    "analyze" -> analyzeMain args
--    "convert" -> convertMain args
--    otherwise -> putStrLn "Bad Sub-command."
