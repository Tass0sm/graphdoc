module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , convertTree_GM
  , writeFromTree_GM ) where

import qualified Treedoc.TreeUtil as TreeUtil
import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Control.Applicative (liftA2)

import Data.Foldable (fold)
import Data.Maybe
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
  let format = formatFromFilePath location
  contents <- saferReadFile location
  return (name, format, contents)

unfolder :: FilePath -> IO (DocNode, [FilePath])
unfolder location = do
  docSource <- getDocSource location
  subFiles <- saferListDirectory location
  return (docSource, subFiles)

readIntoTree_GM :: FilePath -> IO (DocTree)
readIntoTree_GM path = do
  tree <- (unfoldTreeM_BF unfolder) path
  return (GenericMarkup, tree)

--- Conversion:

convertNode :: P.Opt -> DocNode -> IO DocNode
convertNode opt (name, format, text) = do
  let newFormat = (P.optTo opt)
  newText <- translateMarkupWithPandoc text opt
  return (name, newFormat, newText)

convertTree_GM :: P.Opt -> DocTree -> IO DocTree
convertTree_GM opt (_, nodeTree) =
  let converter = convertNode opt
  in do
    newTree <- traverse converter nodeTree
    return (GenericMarkup, newTree)
     
--- Writing:

writeLeaf :: DocNode -> IO ()
writeLeaf (path, format, text) =
  let extension = extensionFromFormat format
      pathWithExtension = path <.> extension
  in writeFile pathWithExtension (T.unpack text)

writeInner :: DocNode -> IO ()
writeInner (path, _, _) =
  createDirectoryIfMissing True path

writeNode :: Bool -> DocNode -> IO ()
writeNode isLeaf node =
  if isLeaf
  then writeLeaf node
  else writeInner node

prependToDocNodeName :: DocNode -> DocNode -> DocNode
prependToDocNodeName (parentName, _, _) (name, format, text) =
  (parentName </> name, format, text)

makeTreeWithAbsoluteNames :: FilePath -> Tree DocNode -> Tree DocNode
makeTreeWithAbsoluteNames prefix tree =
  TreeUtil.mapWithNewParent prependToDocNodeName (prefix, Nothing, T.empty) tree

writeFromTree_GM :: DocTree -> FilePath -> IO ()
writeFromTree_GM (_, tree) output =
  let treeWithAbsoluteNames = makeTreeWithAbsoluteNames output tree
  in fold $ TreeUtil.mapWithLeafCondition writeNode treeWithAbsoluteNames
