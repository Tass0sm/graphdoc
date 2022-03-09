module Graphdoc.Parsing.Util
  ( hasType ) where

import Data.Data

hasType :: Data a => String -> a -> Bool
hasType t = (t==) . show . toConstr
