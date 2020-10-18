 module Treedoc.App
  ( convertTreeWithOpts
  , T.defaultOpts
  , module Treedoc.App.CommandLineOptions ) where

import qualified Text.Pandoc.App as P
import qualified Treedoc.App.Opt as T

import Treedoc.App.CommandLineOptions
import Treedoc.Readers
import Treedoc.Writers

import Data.Maybe
import Data.Tree

-- Impure:

convertTreeWithOpts :: T.Opt -> P.Opt -> IO ()
convertTreeWithOpts treedocOpt pandocOpt = do
  -- This throws an error if no input path was provided. It does what I want, but
  -- I don't think its the right way to do this.
  let inputPath = fromJust (T.optInputPath treedocOpt)
  let outputPath = fromJust (T.optOutputPath treedocOpt)

  let fromFormat = (T.optFrom treedocOpt)
  let treeReader = getTreeReader fromFormat
  tree <- treeReader inputPath

  let toFormat = (T.optTo treedocOpt)
  let treeWriter = getTreeWriter toFormat
  treeWriter outputPath "." tree pandocOpt

