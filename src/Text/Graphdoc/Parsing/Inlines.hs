module Text.Graphdoc.Parsing.Inlines
  ( softbreak
  , inline
  , anyInline ) where

import Text.Graphdoc.Parsing.Shared
import Text.Pandoc.Definition (Inline (..))

import Control.Monad.Identity

import Text.Parsec hiding ( satisfy )
import Text.Parsec.Pos
import Text.Parsec.Prim
import Text.Parsec.Combinator

softbreak = inline "SoftBreak"
inline t = satisfy $ hasType t
anyInline = satisfy (const True)

satisfy :: (Inline -> Bool) -> ParsecT [Inline] () Identity Inline
satisfy f = tokenPrim showInline nextPos testInline
  where showInline = show
        nextPos pos _ _ = incSourceColumn pos 1
        testInline i = if f i
                       then Just i
                       else Nothing
