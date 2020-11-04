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

readIntoTree_TI :: FilePath -> IO (Tree DocNode)
readIntoTree_TI path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: DocNode -> FilePath -> P.Opt -> IO ()
convertLeaf input output opt = undefined

convertInner :: FilePath -> IO ()
convertInner output = undefined
  
convertNode :: DocNode -> FilePath -> FilePath -> Bool -> P.Opt -> IO ()
convertNode input root output isLeaf opt = undefined

writeFromTree_TI :: Tree DocNode -> FilePath -> P.Opt -> IO ()
writeFromTree_TI tree output opt = putStrLn $ drawTree $ T.unpack <$> ((\(_, _, x) -> x) <$> tree)

--  let root = fst rootSource
--      converter = (\isLeaf input -> convertNode input root output isLeaf opt)
--  in fold $ mapTreeWithLeafCondition converter tree
