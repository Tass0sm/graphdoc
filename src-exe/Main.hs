module Main where

import Control.Monad
import Graphdoc.Analysis
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
  let sGraph = gmap show graph
  putStrLn $ exportAsIs sGraph

  --putStrLn $ exportAsIs graph
  --mapM_ (putStrLn . show) pairs

--  files <- listDirectoryRecursively "./src"
--  mapM_ putStrLn files

--  (subcommand:args) <- getArgs
--  case subcommand of
--    "analyze" -> analyzeMain args
--    "convert" -> convertMain args
--    otherwise -> putStrLn "Bad Sub-command."
