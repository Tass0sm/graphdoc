 module Treedoc.App
  ( convertWithOpts
  , T.parseOptions
  , T.parseOptionsFromArgs
  , T.options
  , T.defaultOpts ) where

import qualified Text.Pandoc.App as P
import qualified Treedoc.App.Opt as T
import qualified Treedoc.App.CommandLineOptions as T
import Treedoc.Readers
import Treedoc.Formats.GenericMarkup

import Data.Maybe
import Data.Tree

-- Impure:

-- Convert from one documentation tree format to another. This is the entire
-- functionality of treedoc.
convertWithOpts :: T.Opt -> P.Opt -> IO ()
convertWithOpts treedocOpt pandocOpt = do
  -- This throws an error if no input path was provided. It does what I want, but
  -- I don't think its the right way to do this.
  let inputPath = fromJust (T.optInputPath treedocOpt)
  let outputPath = fromJust (T.optOutputPath treedocOpt)

  let fromFormat = (T.optFrom treedocOpt)
  let treeReader = getTreeReader fromFormat
  tree <- treeReader inputPath

  writeFromTree_GM outputPath "." tree pandocOpt

