module Main where

-- analyzeMain :: [String] -> IO ()
-- analyzeMain args = do
--   opt <- A.parseOptionsFromArgs args
--   A.runAnalysis opt
-- 
-- convertMain :: [String] -> IO ()
-- convertMain args = undefined

import Control.Monad
import Graphdoc.Analysis
import System.Environment
import Algebra.Graph.Export.Dot

main :: IO ()
main = do
  arg <- head <$> getArgs
  graph <- analyzeHTML arg
  putStrLn "WIP"
  --putStrLn $ exportAsIs graph
  --mapM_ (putStrLn . show) pairs

--  files <- listDirectoryRecursively "./src"
--  mapM_ putStrLn files

--  (subcommand:args) <- getArgs
--  case subcommand of
--    "analyze" -> analyzeMain args
--    "convert" -> convertMain args
--    otherwise -> putStrLn "Bad Sub-command."
  
--  args <- getArgs
--  (treedocOpt, otherArgs) <- T.parseOptionsFromArgs args T.options T.defaultOpts
--  pandocOpt <- P.parseOptionsFromArgs otherArgs P.options P.defaultOpts
--  T.convertTreeWithOpts treedocOpt pandocOpt

--  E.catch (parseOptions options defaultOpts >>= convertWithOpts)
--          (handleError . Left)
