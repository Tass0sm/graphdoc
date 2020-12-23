module Graphdoc.Analysis.Opt
  ( Opt (..)
  , defaultOpts ) where

import Graphdoc.Definition

-- Options for a graphdoc analysis run. 
data Opt = Opt
    { optFormat     :: DocFormat      -- Format
    , optInputPath  :: Maybe FilePath -- Input File/Directory Location
    , optOutputPath :: Maybe FilePath -- Output File Location
    } deriving (Show)

-- Default options for a graphdoc analysis run. 
defaultOpts :: Opt
defaultOpts = Opt
  { optFormat = GenericMarkup
  , optInputPath = Nothing
  , optOutputPath = Nothing }
