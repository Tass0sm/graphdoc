module Text.Graphdoc.Parsing.Blocks
  ( liftInlineParser
  , inlineBlock
  , bulletList
  , header
  , nonBlock
  , block
  , anyBlock ) where

import Text.Graphdoc.Parsing.Shared
import Text.Pandoc.Definition

import Control.Monad.Identity

import Data.List
import Data.Tree

import Control.Arrow
import Control.Monad.Trans

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

-- Inlines

liftInlineParser :: InlineParser a -> BlockParser a
liftInlineParser p = do
  ils <- inlineBlock
  liftParser "Inner Inlines" p ils

inlineBlock = do
  b <- choice $ fmap block ["Plain", "Para", "LineBlock", "Header"]
  return $ case b of
             (Plain ils) -> ils
             (Para ils) -> ils
             (LineBlock ilss) -> concat ilss
             (Header _ _ ils) -> ils
             otherwise -> error "Unreachable"

-- Complex

bulletList :: BlockParser (Forest [Block])
bulletList = do
  (BulletList s) <- block "BulletList"
  return $ reformBulletList s

reformBulletList :: [[Block]] -> Forest [Block]
reformBulletList items =
  let getContentsAndSublists item = second (concatMap (\(BulletList s) -> s)) $
                                    partition (not . (hasType "BulletList")) item
  in unfoldForest getContentsAndSublists items

-- Basic

header i = satisfy isHeader
  where isHeader (Header l _ _) = i == l

block t = satisfy $ hasType t

nonBlock t = satisfy $ not . hasType t

anyBlock = satisfy (const True)

satisfy :: (Block -> Bool) -> BlockParser Block
satisfy f = tokenPrim showBlock nextPos testBlock
  where showBlock = show
        nextPos pos b bs = incSourceColumn pos 1
        testBlock b = if f b
                      then Just b
                      else Nothing
