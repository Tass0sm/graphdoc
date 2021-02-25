module Graphdoc.Analysis.HTML
  ( analyzeHTML ) where

import Graphdoc.Definition
import Graphdoc.Analysis.Util
import Graphdoc.Analysis.HTML.Links

import qualified Data.Text.IO as TIO

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

getDocEdges :: FilePath -> IO [(String,  FilePath, FilePath)]
getDocEdges file = do
  src <- TIO.readFile file
  let links = getNamedLinks src
  mapM resolveLinkPair links
    where resolveLinkPair = \(rel, ref) -> do
            newRef <- resolveLink file ref
            return (rel, file, newRef)

getEveryEdge :: FilePath -> IO [(String, FilePath, FilePath)]
getEveryEdge topdir = do
  files <- getSourceFiles sourceP topdir
  concat <$> mapM getDocEdges files

---------------------------------------------------------------------------
--                     Convert Edge List to Vertices                     --
---------------------------------------------------------------------------    
getMetadata :: FilePath -> DocMeta
getMetadata file = DocMeta { docMetaFormat = "HTML"
                           , docMetaTitle = takeBaseName file
                           , docMetaPath = file
                           }

getVertex :: FilePath -> DocNode
getVertex file = DocNode (getMetadata file) (File file)

analyzeHTML :: FilePath -> IO DocGraph
analyzeHTML topdir = do
  edgeList <- getEveryEdge topdir
  let docEdgeList = map toDocEdge edgeList
  return $ edges docEdgeList
    where toDocEdge = \(rel, origin, dest) ->
                        (rel, getVertex origin, getVertex dest)
