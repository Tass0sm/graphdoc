module Treedoc.Converter
  ( makeConverter ) where

import qualified Text.Pandoc.App as Pandoc (Opt)
import qualified Treedoc.Opt as Treedoc (Opt)
import Treedoc.Definition
import Data.Text


-- getMarkupConverter :: Pandoc.Opt -> (Text -> Text)
-- getMarkupConverter = undefined

getDocConverter :: Pandoc.Opt -> DocSource -> IO ()
getDocConverter = undefined
