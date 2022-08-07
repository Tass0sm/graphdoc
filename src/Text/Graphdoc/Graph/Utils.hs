module Text.Graphdoc.Graph.Utils
  ( pathToID
  , idToPath
  , idToContent
  , orderedDFS
  , getDocEnv
  , getFiles) where

import System.Directory.Tree
import Text.Graphdoc.Graph.Definition
import Text.Graphdoc.Definition
import Control.Monad.Reader
import Control.Applicative
import qualified Data.Map as M
import qualified Data.Text as T
import Data.Maybe
import Data.Tree

pathToID :: FilePath -> Reader DocEnv (Maybe NodeID)
pathToID p = asks $ lookup1
  where lookup1 (e, _, _) = M.lookup p e

idToPath :: NodeID -> Reader DocEnv (Maybe FilePath)
idToPath i = asks $ lookup2
  where lookup2 (_, e, _) = M.lookup i e

idToContent :: NodeID -> Reader DocEnv (Maybe T.Text)
idToContent i = asks $ lookup3
  where lookup3 (_, _, e) = M.lookup i e

orderedDFS :: M.Map FilePath [(Edge, FilePath)] -> FilePath -> Tree FilePath
orderedDFS g s = undefined

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
