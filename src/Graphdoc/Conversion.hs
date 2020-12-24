module Graphdoc.Conversion
  ( runConversion ) where

import Graphdoc.Conversion.Opt

runConversion :: Opt -> IO ()
runConversion opt = do
  putStrLn "hello"
