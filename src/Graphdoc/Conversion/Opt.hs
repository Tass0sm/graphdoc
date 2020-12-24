module Graphdoc.Conversion.Opt
  ( Opt (..)
  , defaultOpts ) where

import Graphdoc.Definition

-- Options for a graphdoc conversion run. 
data Opt = Opt
    { optToFormat   :: DocFormat      -- Input format
    , optInputPath  :: Maybe FilePath -- Input DocGraph File / Docs Location
    , optOutputPath :: Maybe FilePath -- Output Docs Location
    } deriving (Show)

-- Default options for a graphdoc analysis run. 
defaultOpts :: Opt
defaultOpts = Opt
  { optToFormat = GenericMarkup
  , optInputPath = Nothing
  , optOutputPath = Nothing }
