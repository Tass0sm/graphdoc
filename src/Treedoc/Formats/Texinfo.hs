{-# LANGUAGE OverloadedStrings #-}

module Treedoc.Formats.Texinfo
  ( readIntoTree_TI
  , convertTree_TI
  , writeFromTree_TI ) where

import qualified Text.Pandoc.Builder as P
import qualified Text.Pandoc.App as P
import qualified Data.Text as T

import Text.Pandoc
import Text.Pandoc.Writers.Texinfo

import Data.Tree

import Treedoc.Definition
import Treedoc.TreeUtil
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

convertNode :: P.Opt -> DocNode -> DocNode
convertNode opt (name, _, pandoc) =
  (name, Just "texinfo", pandoc)

convertTree_TI :: P.Opt -> DocTree -> DocTree
convertTree_TI opt (_, nodeTree) =
  let converter = convertNode opt
      newTree = converter <$> nodeTree
  in (Texinfo, newTree)
     
--- Writing:
  
writeNode :: DocNode -> FilePath -> IO ()
writeNode (_, _, pandoc) outputPath = do
  result <- runIO $ do
    writeTexinfoWithoutTop def pandoc
  text <- handleError result  
  appendFile outputPath (T.unpack text)

writeFromTree_TI :: DocTree -> FilePath -> IO ()
writeFromTree_TI (_, nodeTree) outputPath =
  let writer = (\input -> writeNode input outputPath)
  in foldMap writer (flatten nodeTree)
