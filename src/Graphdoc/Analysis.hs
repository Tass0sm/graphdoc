module Graphdoc.Analysis
  ( module Graphdoc.Analysis.Opt
  , module Graphdoc.Analysis.CLI
  , runAnalysis ) where

import Graphdoc.Analysis.Opt
import Graphdoc.Analysis.CLI

runAnalysis :: Opt -> IO ()
runAnalysis opt = do
  putStrLn "hello"
