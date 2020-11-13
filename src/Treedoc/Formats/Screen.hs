module Treedoc.Formats.Screen
  ( convertTree_SC
  , writeFromTree_SC ) where

import qualified Text.Pandoc.App as P

import Treedoc.Definition

import Data.Tree

-- Impure Code:
--- Reading: N/A
--- Conversion:

convertTree_SC :: P.Opt -> DocTree -> DocTree
convertTree_SC _ docTree = docTree

--- Writing:

formatNode :: DocNode -> String
formatNode (name, format, _) = "(" ++ name ++ ", " ++ show format ++ ")"

formatTree :: Tree DocNode -> String
formatTree tree = drawTree $ formatNode <$> tree

printTree :: Tree DocNode -> IO ()
printTree tree = putStrLn $ formatTree tree

writeFromTree_SC :: DocTree -> FilePath -> IO ()
writeFromTree_SC (format, tree) _ = do
  putStrLn $ show format
  printTree tree
