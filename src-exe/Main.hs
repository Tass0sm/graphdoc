module Main where

import Graphdoc.Analysis
import Graphdoc.Conversion
import Graphdoc.Output

import System.Environment

main :: IO ()
main = do
  arg <- head <$> getArgs
  putStrLn arg
