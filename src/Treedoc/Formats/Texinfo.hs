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

unfolder :: FilePath -> PandocIO (DocNode, [FilePath])
unfolder path = undefined

readIntoTree_TI :: FilePath -> PandocIO (DocTree)
readIntoTree_TI path = do
  tree <- (unfoldTreeM_BF unfolder) path
  return (Texinfo, tree)

--- Conversion:

wrapPandocWithNamedNode :: String -> Pandoc -> Pandoc
wrapPandocWithNamedNode name pandoc =
  mappend (P.doc $ P.header 1 (P.text (T.pack name))) pandoc

convertLeaf :: P.Opt -> DocNode -> DocNode
convertLeaf opt (name, _, pandoc) =
  let pandocWithWrapping = wrapPandocWithNamedNode name pandoc
  in (name, Just "texinfo", pandocWithWrapping)

convertInner :: P.Opt -> DocNode -> DocNode
convertInner opt (name, _, pandoc) =
  let pandocWithWrapping = P.doc $ P.header 1 (P.text (T.pack name))
                           <> P.para "Filler Inserted By Treedoc.\n\n"
  in (name, Just "texinfo", pandocWithWrapping)

convertNode :: P.Opt -> Bool -> DocNode -> DocNode
convertNode opt isLeaf node =
  if isLeaf
  then convertLeaf opt node
  else convertInner opt node

convertTree_TI :: P.Opt -> DocTree -> DocTree
convertTree_TI opt (_, nodeTree) =
  let converter = convertNode opt
      newTree = mapWithLeafCondition converter nodeTree
  in (Texinfo, newTree)
     
--- Writing:
  
writeFromTree_TI :: WriterOptions -> DocTree -> FilePath -> IO ()
writeFromTree_TI options (_, nodeTree) outputPath =
  let pandocTree = (\(_, _, x) -> x) <$> nodeTree
      completePandoc = mconcat $ flatten pandocTree
  in do
    result <- runIO $ do
      writeTexinfo options completePandoc
    text <- handleError result  
    writeFile outputPath (T.unpack text)
