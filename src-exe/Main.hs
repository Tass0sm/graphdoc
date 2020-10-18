module Main where

import qualified Text.Pandoc.App as P
import qualified PandocOptionsUtil as P
import qualified Treedoc as T

import System.Environment

main :: IO ()
main = do
  args <- getArgs
  (treedocOpt, otherArgs) <- T.parseOptionsFromArgs args T.options T.defaultOpts
  pandocOpt <- P.parseOptionsFromArgs otherArgs P.options P.defaultOpts
  T.convertTreeWithOpts treedocOpt pandocOpt

--  E.catch (parseOptions options defaultOpts >>= convertWithOpts)
--          (handleError . Left)
