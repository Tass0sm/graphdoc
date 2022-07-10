{-# LANGUAGE FlexibleContexts #-}

module Text.Graphdoc.Parsing.Shared
  ( traverseParser
  , liftParser
  , BlockParser
  , InlineParser
  , hasType ) where

import Data.Data

import Text.Pandoc.Definition (Block (..))

import Data.Functor.Identity as F
import Control.Monad.Identity as M

import Data.List
import Data.Tree

import Control.Arrow
import Control.Monad.Trans

import Text.Pandoc

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

traverseParser :: (Stream s F.Identity t, Traversable b) => b s -> ParsecT s u M.Identity a -> ParsecT s u M.Identity (b a)
traverseParser t p = traverse (liftParser "Node" p) t

liftParser :: Stream s m t => SourceName -> ParsecT s u m a -> s -> ParsecT s1 u m a
liftParser name p s = do
  u <- getState
  r <- lift $ runParserT p u name s
  case r of
    Right x -> return x
    Left e -> undefined

type BlockParser = ParsecT [Block] () M.Identity

type InlineParser = ParsecT [Inline] () M.Identity

hasType :: Data a => String -> a -> Bool
hasType t = (t==) . show . toConstr
