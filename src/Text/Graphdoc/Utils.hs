module Text.Graphdoc.Utils
  ( findByPath
  , findByBasename ) where

import Text.Graphdoc.Definition
import System.Directory.Tree
import System.FilePath
import Data.Maybe
import Data.Text as T
import Data.List as L

findByPath :: FileName -> GraphSource -> Maybe T.Text
findByPath path s = snd <$> L.find hasPath (zipRelativePaths s)
  where hasPath = (path ==) . fst

zipRelativePaths :: AnchoredDirTree a -> DirTree (FilePath, a)
zipRelativePaths (_ :/ (Dir _ cs)) = Dir "." $ L.map (zipRP ".") cs
  where zipRP p (Dir n cs)   = Dir n $ L.map (zipRP $ p</>n) cs
        zipRP p (File n a)   = File n (p</>n , a)
        zipRP _ (Failed n e) = Failed n e

findByBasename :: FileName -> GraphSource -> Maybe T.Text
findByBasename name s = snd <$> L.find hasName (zipBaseNames s)
  where hasName = (name ==) . fst

zipBaseNames :: AnchoredDirTree a -> DirTree (FilePath, a)
zipBaseNames (_ :/ t) = zipBN t
    where zipBN (Dir n cs)   = Dir n $ L.map zipBN cs
          zipBN (File n a)   = File n (n , a)
          zipBN (Failed n e) = Failed n e
