module Main where

import qualified Text.Pandoc.App as P
import qualified Treedoc as T

-- convertFileWithOpts :: [FilePath] -> Opt -> IO ()
-- convertFileWithOpts files opt = convertWithOpts $ opt {optInputFiles = Just files}

main :: IO ()
main = do
  treedocOpt <- T.parseOptions T.options T.defaultOpts
  pandocOpt <- P.parseOptions P.options P.defaultOpts
  T.convertWithOpts treedocOpt pandocOpt

--  E.catch (parseOptions options defaultOpts >>= convertWithOpts)
--          (handleError . Left)
