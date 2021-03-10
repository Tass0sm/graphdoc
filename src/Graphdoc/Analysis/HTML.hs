module Graphdoc.Analysis.HTML
  ( analyzeHTML ) where

import Graphdoc.Definition
import Graphdoc.Analysis.Util
import Graphdoc.Analysis.HTML.Links

import qualified Data.Text.IO as TIO

import Text.Pandoc
import Algebra.Graph.Labelled.AdjacencyMap
import System.FilePath
import System.Directory (canonicalizePath)
import Control.Exception

-- TODO: Add predicate DSL?
sourceP :: Predicate
sourceP file = "html" `isExtensionOf` file

----------------------------------------------------------------
--                       Find All Edges                       --
----------------------------------------------------------------
resolveLink :: FilePath -> String -> IO FilePath
resolveLink originFile link =
  let originDir = takeDirectory originFile
      rawPath = originDir </> link
  in canonicalizePath rawPath

getFileEdges :: FilePath -> IO [(String,  FilePath, FilePath)]
getFileEdges file = do
  src <- TIO.readFile file
  let links = getNamedLinks src
  mapM resolveLinkPair links
    where resolveLinkPair = \(rel, ref) -> do
            newRef <- resolveLink file ref
            return (rel, file, newRef)

getEveryFileEdge :: FilePath -> IO [(String, FilePath, FilePath)]
getEveryFileEdge topdir = do
  files <- getSourceFiles sourceP topdir
  concat <$> mapM getFileEdges files

---------------------------------------------------------------------------
--                     Convert Edge List to Vertices                     --
---------------------------------------------------------------------------    
getMetadata :: FilePath -> DocMeta
getMetadata file = DocMeta { docMetaFormat = "HTML"
                           , docMetaPath = file
                           , docMetaIsTop = False
                           }

getVertex :: FilePath -> IO DocNode
getVertex file = do
  text <- TIO.readFile file
  let result = runPure $ readHtml def text
  doc <- handleError result
  return $ DocNode (getMetadata file) (Doc doc)

toDocEdge :: (String, FilePath, FilePath) -> IO (String, DocNode, DocNode)
toDocEdge (s, f1, f2) = do
  v1 <- getVertex f1
  v2 <- getVertex f2
  return (s, v1, v2)

analyzeHTML :: FilePath -> IO DocGraph
analyzeHTML topdir = do
  fileEdgeList <- getEveryFileEdge topdir
  docEdgeList <- mapM toDocEdge fileEdgeList
  return $ edges docEdgeList

