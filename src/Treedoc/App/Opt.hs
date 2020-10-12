module Treedoc.App.Opt
  ( Opt (..)
  , defaultOpts ) where

import Treedoc.Definition

data Opt = Opt
    { optFrom       :: Format         -- Input format
    , optTo         :: Format         -- Output format
    , optInputPath  :: Maybe FilePath -- Input File Location
    , optOutputPath :: Maybe FilePath -- Output File Location
    }

defaultOpts :: Opt
defaultOpts = Opt
  { optFrom = GenericMarkup
  , optTo   = GenericMarkup
  , optInputPath = Nothing
  , optOutputPath = Nothing }
