module Text.Graphdoc.Utils
  ( findInSource
  , myFind ) where

import Text.Graphdoc.Definition
import System.Directory.Tree
import Data.Maybe
import Data.Text as T
import Data.List as L

findInSource :: GraphSource -> FileName -> Maybe T.Text
findInSource tree filename = myFind (== filename) (dirTree tree)

myFind :: (FileName -> Bool) -> DirTree a -> Maybe a
myFind f (Dir n cs)   = firstJust $ L.map (myFind f) cs
myFind f (File n a)   = if f n then Just a else Nothing
myFind _ (Failed _ _) = Nothing

firstJust :: [Maybe a] -> Maybe a
firstJust = listToMaybe . catMaybes
