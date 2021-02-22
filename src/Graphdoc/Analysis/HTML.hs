module Graphdoc.Analysis.HTML
  ( analyzeHTML ) where

import Graphdoc.Definition
import Graphdoc.Util

import System.FilePath

-- TODO: Add predicate DSL?
sourceP :: Predicate
sourceP file = "html" `isExtensionOf` file

getMetadata :: FilePath -> Meta
getMetadata file = Meta { metaFormat = "HTML"
                        , metaTitle = "Unknown"
                        , metaPath = file
                        }

getDocNodes :: FilePath -> IO [DocNode]
getDocNodes topdir = do
  files <- getSourceFiles sourceP topdir
  let sources = map File files
  let metadata = map getMetadata files
  return $ zip metadata sources

extractLinks :: FilePath -> IO [String]
extractLinks path = handle (\_ -> return []) $
  bracket (openFile path ReadMode) (hClose) $ \h -> do
  

getOutEdges :: DocNode -> [DocNode] -> IO [DocEdge]
getOutEdges = undefined

analyzeHTML :: FilePath -> IO DocGraph
analyzeHTML = undefined
