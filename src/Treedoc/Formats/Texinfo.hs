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

unfolder :: FilePath -> IO (DocSource, [FilePath])
unfolder path = undefined

readIntoTree_TI :: FilePath -> IO (Tree DocSource)
readIntoTree_TI path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: FilePath -> FilePath -> P.Opt -> IO ()
convertLeaf source output opt = undefined

convertInner :: FilePath -> FilePath -> IO ()
convertInner source output = undefined
  
convertNode :: FilePath -> FilePath -> FilePath -> Bool -> P.Opt -> IO ()
convertNode root input output isLeaf opt =
  if isLeaf
  then convertLeaf input absoluteOutput opt
  else convertInner input absoluteOutput
  where
    absoluteOutput = translatePath root input output
  
writeFromTree_TI :: FilePath -> Tree DocSource -> P.Opt -> IO ()
writeFromTree_TI output tree@(Node root children) opt = undefined

--  let converter = (\isLeaf input -> convertNode root input output isLeaf opt)
--  in fold $ mapTreeWithLeafCondition converter tree
