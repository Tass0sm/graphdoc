module Treedoc.App
  ( convertWithOpts
  , T.parseOptions
  , T.options
  , T.defaultOpts ) where

import qualified Text.Pandoc.App as P
import qualified Treedoc.App.Opt as T
import qualified Treedoc.App.CommandLineOptions as T

-- Impure:

-- Convert from one documentation tree format to another. This is the entire
-- functionality of treedoc.
convertWithOpts :: T.Opt -> P.Opt -> IO ()
convertWithOpts treedocOpt pandocOpt = do
  putStrLn "Hello"
