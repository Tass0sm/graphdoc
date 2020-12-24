module Graphdoc.Analysis
  ( module Graphdoc.Analysis.Opt
  , module Graphdoc.Analysis.CLI
  , runAnalysis ) where

import Data.Maybe

import Graphdoc.Analysis.Opt
import Graphdoc.Analysis.CLI

runAnalysis :: Opt -> IO ()
runAnalysis opt = do
  let inputPath = fromMaybe "." (optInputPath opt)
  let outputPath = fromMaybe "." (optOutputPath opt)
  let format = optFormat opt
  putStrLn inputPath
