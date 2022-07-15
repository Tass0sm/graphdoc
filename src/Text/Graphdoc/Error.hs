module Text.Graphdoc.Error
  ( GraphdocError(..)
  , renderError ) where

import qualified Text.Pandoc.Error as PD
import qualified Text.Parsec.Error as PS
import Data.Text

data GraphdocError = GraphdocPandocError PD.PandocError
                   | GraphdocParserError PS.ParseError

renderError :: GraphdocError -> Text
renderError e =
  case e of
    GraphdocPandocError e -> PD.renderError e
    GraphdocParserError e -> undefined
