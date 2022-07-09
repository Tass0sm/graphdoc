module Text.Graphdoc.Parsing.Shared
  ( BlockParser
  , InlineParser
  , hasType ) where

import Data.Data

import Text.Pandoc.Definition (Block (..))

import Control.Monad.Identity

import Data.List
import Data.Tree

import Control.Arrow
import Control.Monad.Trans

import Text.Pandoc

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

type BlockParser = ParsecT [Block] () Identity

type InlineParser = ParsecT [Inline] () Identity

hasType :: Data a => String -> a -> Bool
hasType t = (t==) . show . toConstr
