module Text.Graphdoc.Parsing.Shared
  ( traverseParser
  , liftParser
  , BlockParser
  , InlineParser
  , hasType ) where

import Control.Monad.Identity
import Control.Monad.Trans
import Data.Data
import Text.Pandoc
import Text.Parsec

traverseParser :: (Stream s m t, Traversable b) => b s -> ParsecT s u m a -> ParsecT s u m (b a)
traverseParser t p = traverse (liftParser "Node" p) t

liftParser :: Stream s m t => SourceName -> ParsecT s u m a -> s -> ParsecT s1 u m a
liftParser name p s = do
  u <- getState
  r <- lift $ runParserT p u name s
  case r of
    Right x -> return x
    Left e -> undefined

type BlockParser = ParsecT [Block] () Identity

type InlineParser = ParsecT [Inline] () Identity

hasType :: Data a => String -> a -> Bool
hasType t = (t==) . show . toConstr
