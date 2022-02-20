module Graphdoc.Parsing.Inlines
  ( anyInline ) where

import Graphdoc.Parsing.Util
import Text.Pandoc.Definition (Inline (..))

import Control.Monad.Identity

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

inline t = satisfy $ hasType t
anyInline = satisfy (const True)

satisfy :: (Inline -> Bool) -> ParsecT [Inline] () Identity Inline
satisfy f = tokenPrim showInline nextPos testInline
  where showInline = show
        nextPos pos _ _ = incSourceColumn pos 1
        testInline i = if f i
                       then Just i
                       else Nothing
