module Main where

import System.Environment
import qualified Data.Text as T
import Data.Tree
import Treedoc

main :: IO ()
main = do
  args <- getArgs
  tree <- readIntoTree $ head args
  let strTree = fmap T.unpack tree in
    putStr $ drawTree strTree
