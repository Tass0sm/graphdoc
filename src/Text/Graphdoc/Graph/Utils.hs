module Text.Graphdoc.Graph.Utils
  ( pathToID
  , idToPath
  , idToContent
  , transposeGraph
  , orderedDFS
  , getDowns
  , getPrev
  , getPrevs
  , getFwd
  , getFwds
  , getOrderedChildren
  , getChild
  , getDocEnv
  , getFiles ) where

import System.Directory.Tree
import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Definition
import Control.Monad.Reader
import Control.Applicative
import qualified Data.Map as M
import qualified Data.Text as T
import Data.Maybe
import Data.Tree
import qualified Data.List as L

pathToID :: FilePath -> Reader DocEnv (Maybe NodeID)
pathToID p = asks $ lookup1
  where lookup1 (e, _, _) = M.lookup p e

idToPath :: NodeID -> Reader DocEnv (Maybe FilePath)
idToPath i = asks $ lookup2
  where lookup2 (_, e, _) = M.lookup i e

idToContent :: NodeID -> Reader DocEnv (Maybe T.Text)
idToContent i = asks $ lookup3
  where lookup3 (_, _, e) = M.lookup i e

transposeGraph :: M.Map FilePath [(Edge, FilePath)] -> M.Map FilePath [(Edge, FilePath)]
transposeGraph = buildG . map reverseEdge . edges

buildG :: [(FilePath, Edge, FilePath)] -> M.Map FilePath [(Edge, FilePath)]
buildG es = L.foldl' addEdgeToMap M.empty es
  where addEdgeToMap m (f, e, t) = M.insertWith (++) f [(e, t)] m

reverseEdge :: (FilePath, Edge, FilePath) -> (FilePath, Edge, FilePath)
reverseEdge (f, Prev, t) = (f, Prev, t)
reverseEdge (f, Fwd, t) = (f, Fwd, t)
reverseEdge (f, e, t) = (t, Reverse e, f)

edges :: M.Map FilePath [(Edge, FilePath)] -> [(FilePath, Edge, FilePath)]
edges = concat . map localEdges . M.toList

localEdges :: (FilePath, [(Edge, FilePath)]) -> [(FilePath, Edge, FilePath)]
localEdges (from, es) = map (addFrom from) es
  where addFrom f (e, to) = (f, e, to)

orderedDFS :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Tree FilePath
orderedDFS g s = Node s (map (orderedDFS g) (getDowns g s))

getOrderedChildren :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
getOrderedChildren g s = let c = getChild g s
                         in case c of
                              Just f -> getPrevs g f ++ getFwds g f
                              Nothing -> []

getDowns :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
getDowns g s = case M.lookup s g of
                 Just conns -> map snd $ filter ((Reverse Up==) . fst) conns
                 Nothing -> []

getSiblings :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
getSiblings g c = getPrevs g c ++ getFwds g c

getFwds :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
getFwds g s = let p = getFwd g s
              in case p of
                   Just f -> f : getFwds g f
                   Nothing -> []

getFwd :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
getFwd g s = listToMaybe $ map snd $ filter ((Fwd==) . fst) $ g M.! s

getPrevs :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
getPrevs g s = let p = getPrev g s
               in case p of
                    Just f -> getPrevs g f ++ [s]
                    Nothing -> [s]

getPrev :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
getPrev g s = listToMaybe $ map snd $ filter ((Prev==) . fst) $ g M.! s

getChild :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
getChild g s = let conns = g M.! s
               in listToMaybe $ map snd $ filter ((Reverse Up==) . fst) conns

getDocEnv :: GraphSource -> DocEnv
getDocEnv s = let fNames = map fst $ getFiles s
                  fContent = map snd $ getFiles s
              in ( M.fromList $ zip fNames [0..]
                 , M.fromList $ zip [0..] fNames
                 , M.fromList $ zip [0..] fContent )

getFiles :: GraphSource -> [(FilePath, T.Text)]
getFiles = map file . filter isFile . flattenDir . zipPaths
  where isFile (File _ _) = True
        isFile _ = False
