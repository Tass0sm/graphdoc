module Graphdoc.Parsing.Blocks
  ( bulletList
  , header
  , nonBlock
  , block
  , anyBlock ) where

import Graphdoc.Parsing.Util
import Text.Pandoc.Definition (Block (..))

import Control.Monad.Identity

import Data.List
import Data.Tree

import Control.Arrow

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

-- Parsing using Pandoc Blocks as Tokens

bulletList :: Parsec [Block] () (Tree [Block])
bulletList = do
  (BulletList s) <- block "BulletList"
  return $ reformBulletList s

reformBulletList :: [[Block]] -> Tree [Block]
reformBulletList items =
  let getContentsAndSublists item = second (concatMap (\(BulletList s) -> s)) $
                                    partition (not . (hasType "BulletList")) item
      children = unfoldForest getContentsAndSublists items
  in Node [] children

header i = satisfy isHeader
  where isHeader (Header l _ _) = i == l

nonBlock t = satisfy $ not . hasType t
block t = satisfy $ hasType t
anyBlock = satisfy (const True)

satisfy :: (Block -> Bool) -> ParsecT [Block] () Identity Block
satisfy f = tokenPrim showBlock nextPos testBlock
  where showBlock = show
        nextPos pos b bs = incSourceColumn pos 1
        testBlock b = if f b
                      then Just b
                      else Nothing
