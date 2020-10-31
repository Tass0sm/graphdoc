module Treedoc.Formats.GenericMarkup
  ( readIntoTree_GM
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

readIntoTree_GM :: FilePath -> IO (Tree DocNode)
readIntoTree_GM path = (unfoldTreeM_BF unfolder) path

--- Writing:

convertLeaf :: DocNode -> P.Opt -> IO ()
convertLeaf (path, format, text) options =
  let newFormat = T.unpack <$> (P.optTo options)
      extension = extensionFromFormat newFormat
      pathWithExtension = path <.> extension
  in convertTextWithOpts text pathWithExtension options

convertInner :: DocNode -> IO ()
convertInner (path, _, _) =
  createDirectoryIfMissing True path
  
convertNode :: Bool -> DocNode -> P.Opt -> IO ()
convertNode isLeaf input options =
  if isLeaf
  then convertLeaf input options
  else convertInner input

prependToDocNodeName :: DocNode -> DocNode -> DocNode
prependToDocNodeName (parentName, _, _) (name, format, text) =
  (parentName </> name, format, text)

makeTreeWithAbsoluteNames :: FilePath -> Tree DocNode -> Tree DocNode
makeTreeWithAbsoluteNames prefix tree =
  TreeUtil.mapWithNewParent prependToDocNodeName (prefix, Nothing, T.empty) tree

writeFromTree_GM :: Tree DocNode -> FilePath -> P.Opt -> IO ()
writeFromTree_GM tree output options =
  let treeWithAbsoluteNames = makeTreeWithAbsoluteNames output tree
      converter = (\isLeaf input -> convertNode isLeaf input options)
  in fold $ TreeUtil.mapWithLeafCondition converter treeWithAbsoluteNames
