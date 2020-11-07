module Treedoc.TreeUtil
  ( mapWithLeafCondition
  , mapWithParent
  , mapWithNewParent
  , traverseWithLeafCondition ) where

import Data.Tree
import Control.Applicative (liftA2)

mapWithLeafCondition :: (Bool -> a -> b) -> Tree a -> Tree b
mapWithLeafCondition f (Node x []) = Node (f True x) []
mapWithLeafCondition f (Node x ts) =
  Node (f False x) (map (mapWithLeafCondition f) ts)

mapWithParent :: (a -> a -> b) -> a -> Tree a -> Tree b
mapWithParent f p (Node x ts) =
  Node (f p x) (map (mapWithParent f x) ts)

mapWithNewParent :: (b -> a -> b) -> b -> Tree a -> Tree b
mapWithNewParent f p (Node x ts) =
  Node x' (map (mapWithNewParent f x') ts)  
  where x' = f p x

traverseWithLeafCondition :: Applicative f => (Bool -> a -> f b) -> Tree a -> f (Tree b)
traverseWithLeafCondition f (Node x []) =
  liftA2 Node (f True x) (pure [])
traverseWithLeafCondition f (Node x ts) =
  liftA2 Node (f False x) (traverse (traverseWithLeafCondition f) ts)

