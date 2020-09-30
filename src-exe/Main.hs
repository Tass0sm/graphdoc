module Main where

import System.Environment
import qualified Data.Text as T
import Data.Tree
import Treedoc

main :: IO ()
main = do
  tree <- readIntoTree "data"
  writeFromTree "example" tree
