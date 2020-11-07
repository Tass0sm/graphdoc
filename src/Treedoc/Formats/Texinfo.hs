module Treedoc.Formats.Texinfo
( readIntoTree_TI
, writeFromTree_TI ) where

import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Data.Foldable (fold)
import Data.Tree

import System.Directory
import System.FilePath

import Treedoc.Definition
import Treedoc.Util

-- Impure Code:
--- Reading:

unfolder :: FilePath -> IO (DocNode, [FilePath])
unfolder path = undefined

readIntoTree_TI :: FilePath -> IO (DocTree)
readIntoTree_TI path = do
  tree <- (unfoldTreeM_BF unfolder) path
  return (Texinfo, tree)

--- Conversion:

convertNode :: P.Opt -> DocNode -> IO DocNode
convertNode opt (name, format, text) = do
  let newFormat = (P.optTo opt)
  newText <- translateMarkupWithPandoc text opt
  return (name, newFormat, newText)

convertTree_TI :: P.Opt -> DocTree -> IO DocTree
convertTree_TI opt (_, nodeTree) =
  let converter = convertNode opt
  in do
    newTree <- traverse converter nodeTree
    return (GenericMarkup, newTree)
     
--- Writing:

convertLeaf :: DocNode -> FilePath -> P.Opt -> IO ()
convertLeaf input output opt = undefined

convertInner :: FilePath -> IO ()
convertInner output = undefined
  
convertNode :: DocNode -> FilePath -> FilePath -> Bool -> P.Opt -> IO ()
convertNode input root output isLeaf opt = undefined

writeFromTree_TI :: DocTree -> FilePath -> IO ()
writeFromTree_TI tree output = undefined

--putStrLn $ drawTree $ T.unpack <$> ((\(_, _, x) -> x) <$> tree)

--  let root = fst rootSource
--      converter = (\isLeaf input -> convertNode input root output isLeaf opt)
--  in fold $ mapTreeWithLeafCondition converter tree
