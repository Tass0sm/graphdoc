module Text.Graphdoc.Graph.Utils
  ( transposeGraph
  , orderedDFS'
  , getOrderedChildren'
  , myOrd'
  , succeeds'
  , preceeds'
  , getFwds'
  , getPrevs' ) where

import System.Directory.Tree
import Text.Graphdoc.Definition
import Control.Monad.Reader
import Control.Applicative
import qualified Data.Map as M
import qualified Data.Text as T
import qualified Data.Graph.Inductive as FGL
import Data.Maybe
import Data.Tree
import qualified Data.List as L

-- pathToID :: FilePath -> Reader DocEnv (Maybe NodeID)
-- pathToID p = asks $ lookup1
--   where lookup1 (e, _, _) = M.lookup p e

-- idToPath :: NodeID -> Reader DocEnv (Maybe FilePath)
-- idToPath i = asks $ lookup2
--   where lookup2 (_, e, _) = M.lookup i e

-- idToContent :: NodeID -> Reader DocEnv (Maybe T.Text)
-- idToContent i = asks $ lookup3
--   where lookup3 (_, _, e) = M.lookup i e

transposeGraph :: FGL.DynGraph gr => gr a GraphdocEdge -> gr a GraphdocEdge
transposeGraph = FGL.gmap transposeContext

transposeContext :: FGL.Context a GraphdocEdge -> FGL.Context a GraphdocEdge
transposeContext (p,v,l,s) = let (p', s') = transposeAdjs p s
                             in (p', v, l, s')

transposeAdjs :: FGL.Adj GraphdocEdge -> FGL.Adj GraphdocEdge -> (FGL.Adj GraphdocEdge, FGL.Adj GraphdocEdge)
transposeAdjs pAdj sAdj = let (spAdj', pAdj') = L.partition toFlip pAdj
                              (psAdj', sAdj') = L.partition toFlip sAdj
                          in (pAdj' ++ map reverseEdge psAdj', sAdj' ++ map reverseEdge spAdj')

toFlip :: (GraphdocEdge, FGL.Node) -> Bool
toFlip (Prev, _) = False
toFlip (Fwd, _) = False
toFlip _ = True

reverseEdge :: (GraphdocEdge, FGL.Node) -> (GraphdocEdge, FGL.Node)
reverseEdge (e, n) = (Reverse e, n)

-- edges :: M.Map FilePath [(Edge, FilePath)] -> [(FilePath, Edge, FilePath)]
-- edges = concat . map localEdges . M.toList

-- localEdges :: (FilePath, [(Edge, FilePath)]) -> [(FilePath, Edge, FilePath)]
-- localEdges (from, es) = map (addFrom from) es
--   where addFrom f (e, to) = (f, e, to)

-- DFS Rewrite:

orderedDFS' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> Tree a
orderedDFS' g s = orderedDFTWith' FGL.lab' g s

orderedDFTWith' :: FGL.DynGraph gr => FGL.CFun a GraphdocEdge c -> gr a GraphdocEdge -> FGL.Node -> Tree c
orderedDFTWith' f g s = head $ FGL.xdffWith (getOrderedChildren' g) f [s] g

getOrderedChildren' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Context a GraphdocEdge -> [FGL.Node]
getOrderedChildren' g = L.sortBy (myOrd' g) . FGL.suc'

myOrd' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> FGL.Node -> Ordering
myOrd' g a b
  | succeeds' g a b = LT
  | preceeds' g a b = GT
  | otherwise = EQ

-- Old:

-- orderedDFS :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Tree FilePath
-- orderedDFS g s = Node s (map (orderedDFS g) (getOrderedChildren g s))

-- getOrderedChildren :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
-- getOrderedChildren g s = let ds = getDowns g s
--                          in L.sortBy (myOrd g) ds

-- myOrd g a b
--   | succeeds g a b = LT
--   | preceeds g a b = GT
--   | otherwise = EQ

-- preceeds :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> FilePath -> Bool
-- preceeds g a b = b `elem` getPrevs g a

preceeds' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> FGL.Node -> Bool
preceeds' g a b = b `elem` getPrevs' g a

-- succeeds :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> FilePath -> Bool
-- succeeds g a b = b `elem` getFwds g a

succeeds' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> FGL.Node -> Bool
succeeds' g a b = b `elem` getFwds' g a

-- topologicalSort :: M.Map FilePath [(Edge, FilePath)] -> [FilePath]
-- topologicalSort = undefined

-- subgraph :: M.Map FilePath [(Edge, FilePath)] -> [FilePath] -> M.Map FilePath [(Edge, FilePath)]
-- subgraph g vs = M.fromList $ map adjs vs
--   where adjs k = (k, safeEdges (g M.! k))
--         safeEdges es = filter isSafe es
--         isSafe x = (fst x == Fwd) && (snd x `elem` vs)

-- getDowns :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
-- getDowns g s = case M.lookup s g of
--                  Just conns -> map snd $ filter ((Reverse Up==) . fst) conns
--                  Nothing -> []

-- getSiblings :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
-- getSiblings g c = getPrevs g c ++ getFwds g c

getFwds' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> [FGL.Node]
getFwds' g s = map (\(_, t, _) -> t) $ filter (\(_, _, e) -> e == Fwd) $ FGL.out g s

-- getFwds :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
-- getFwds g s = let p = getFwd g s
--               in case p of
--                    Just f -> f : getFwds g f
--                    Nothing -> []

-- getFwd :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
-- getFwd g s = let mes = M.lookup s g
--              in case mes of
--                   Just es -> listToMaybe $ map snd $ filter ((Fwd==) . fst) es
--                   Nothing -> Nothing

getPrevs' :: FGL.DynGraph gr => gr a GraphdocEdge -> FGL.Node -> [FGL.Node]
getPrevs' g s = map (\(_, t, _) -> t) $ filter (\(_, _, e) -> e == Prev) $ FGL.out g s

-- getPrevs :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> [FilePath]
-- getPrevs g s = let p = getPrev g s
--                in case p of
--                     Just f -> getPrevs g f ++ [s]
--                     Nothing -> [s]

-- getPrev :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
-- getPrev g s = let mes = M.lookup s g
--              in case mes of
--                   Just es -> listToMaybe $ map snd $ filter ((Prev==) . fst) es
--                   Nothing -> Nothing

-- getChild :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Maybe FilePath
-- getChild g s = let conns = g M.! s
--                in listToMaybe $ map snd $ filter ((Reverse Up==) . fst) conns

-- getDocEnv :: GraphSource -> DocEnv
-- getDocEnv s = let fNames = map fst $ getFiles s
--                   fContent = map snd $ getFiles s
--               in ( M.fromList $ zip fNames [0..]
--                  , M.fromList $ zip [0..] fNames
--                  , M.fromList $ zip [0..] fContent )

-- getFiles :: GraphSource -> [(FilePath, T.Text)]
-- getFiles = map file . filter isFile . flattenDir . zipPaths
--   where isFile (File _ _) = True
--         isFile _ = False
