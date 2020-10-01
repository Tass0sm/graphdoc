module Main where

import System.Environment
import qualified Data.Text as T
import Data.Tree
import Treedoc

main :: IO ()
main = do
  args <- getArgs
  tree <- readIntoTree $ head args
  writeFromTree (head $ tail args) tree
