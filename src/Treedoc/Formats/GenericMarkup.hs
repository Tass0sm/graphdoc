module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , writeFromTree_GM ) where

import qualified Treedoc.TreeUtil as TreeUtil
import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Control.Applicative (liftA2)

import Data.Foldable (fold)
import Data.Tree

import System.Directory
import System.FilePath

import Treedoc.Definition
import Treedoc.Util

-- Impure Code:
--- Reading:

getDocSource :: FilePath -> IO DocNode
getDocSource location = do
  let name = takeBaseName location
  contents <- saferReadFile location
  return (name, contents)

unfolder :: FilePath -> IO (DocNode, [FilePath])
unfolder location = do
  docSource <- getDocSource location
  subFiles <- saferListDirectory location
  return (docSource, subFiles)

readIntoTree_GM :: FilePath -> IO (Tree DocNode)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: DocNode -> FilePath -> P.Opt -> IO ()
convertLeaf input output options = undefined

--  let inputFile = fst input
--  in convertFileWithOpts inputFile output opt

convertInner :: FilePath -> IO ()
convertInner output = undefined

-- createDirectoryIfMissing True output
  
convertNode :: DocNode -> FilePath -> P.Opt -> IO ()
convertNode input output options = undefined

--  if isLeaf
--  then convertLeaf input absoluteOutput opt
--  else convertInner absoluteOutput
--  where
--    inputLocation = fst input
--    absoluteOutput = translatePath root inputLocation output

makeOutputPathTree :: FilePath -> Tree DocNode -> Tree FilePath
makeOutputPathTree prefix tree =
  let nameTree = fst <$> tree
  in TreeUtil.mapWithNewParent (</>) prefix nameTree

writeFromTree_GM :: Tree DocNode -> FilePath -> P.Opt -> IO ()
writeFromTree_GM tree output options =
  let outputPathTree = makeOutputPathTree output tree
      converter = (\inputNode outputPath -> convertNode inputNode outputPath options)
  in do
    putStrLn $ drawTree outputPathTree
--    fold $ liftA2 converter tree outputPathTree
  
--  let root = fst rootSource
--      converter = (\isLeaf input -> convertNode input root output isLeaf opt)
--  in fold $ mapTreeWithLeafCondition converter tree
