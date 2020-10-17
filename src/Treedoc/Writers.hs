module Treedoc.Writers
  ( getTreeWriter
  , writeFromTree_GM ) where

import qualified Text.Pandoc.App as P

import Treedoc.Formats.GenericMarkup (writeFromTree_GM)
import Treedoc.Definition

import Data.Tree

getTreeWriter :: Format -> FilePath -> FilePath -> Tree DocSource -> P.Opt -> IO ()
getTreeWriter format = case format of
  GenericMarkup -> writeFromTree_GM
  _ -> undefined
