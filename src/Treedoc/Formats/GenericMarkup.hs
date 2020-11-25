module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
  , convertTree_GM
  , writeFromTree_GM ) where

import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Control.Monad.Trans

import Data.Foldable (fold)
import Data.Maybe
import Data.Tree

import System.Directory
import System.FilePath

import Text.Pandoc
import Text.Pandoc.Builder (doc)
import Text.Pandoc.Options (WriterOptions)

import Treedoc.Definition
import Treedoc.TreeUtil
import Treedoc.Util

-- Impure Code:
--- Reading:

getDocSource :: FilePath -> IO DocNode
getDocSource location = do
  let name = takeBaseName location
  let format = formatFromFilePath location
  pandoc <- getPandocFromFileWithFormat format location def
  return (name, format, pandoc)

unfolder :: FilePath -> PandocIO (DocNode, [FilePath])
unfolder location = liftIO $ do
    docSource <- getDocSource location
    subFiles <- saferListDirectory location
    return (docSource, subFiles)

readIntoTree_GM :: FilePath -> PandocIO DocTree
readIntoTree_GM path = do
  tree <- unfoldTreeM_BF unfolder path
  return (GenericMarkup, tree)

--- Conversion:

convertLeaf :: P.Opt -> DocNode -> DocNode
convertLeaf opt (name, _, pandoc) =
  let newFormat = (P.optTo opt)
  in (name, newFormat, pandoc)

convertNode :: P.Opt -> Bool -> DocNode -> DocNode
convertNode opt isLeaf node@(name, _, pandoc) =
  if isLeaf
  then convertLeaf opt node
  else node

convertTree_GM :: P.Opt -> DocTree -> DocTree
convertTree_GM opt (_, nodeTree) =
  let converter = convertNode opt
      newTree = mapWithLeafCondition converter nodeTree
  in (GenericMarkup, newTree)
     
--- Writing:

writeLeaf :: DocNode -> IO ()
writeLeaf (path, format, pandoc) = do
  let extension = extensionFromFormat format
  let pathWithExtension = path <.> extension
  newText <- getMarkupFromPandocWithFormat format pandoc def
  writeFile pathWithExtension (T.unpack newText)

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
  let emptyPandoc = doc $ mempty
      rootParent = (prefix, Nothing, emptyPandoc)
  in mapWithNewParent prependToDocNodeName rootParent tree

writeFromTree_GM :: WriterOptions -> DocTree -> FilePath -> IO ()
writeFromTree_GM options (_, tree) output =
  let treeWithAbsoluteNames = makeTreeWithAbsoluteNames output tree
  in fold $ mapWithLeafCondition writeNode treeWithAbsoluteNames
