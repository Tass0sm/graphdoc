{-# LANGUAGE CPP #-}

module PandocOptionsUtil
  ( parseOptionsFromArgs ) where

import qualified Text.Pandoc.UTF8 as UTF8
import qualified Control.Exception as E
import qualified Data.Text as T

import System.Environment (getArgs, getProgName)
import System.Console.GetOpt
import Control.Monad
import Data.Maybe

import Text.Pandoc
import Text.Pandoc.App

parseOptionsFromArgs :: [String] -> [OptDescr (Opt -> IO Opt)] -> Opt -> IO Opt
parseOptionsFromArgs args options' defaults = do
  rawArgs <- map UTF8.decodeArg <$> return args
  prg <- getProgName

  let (actions, args, unrecognizedOpts, errors) =
           getOpt' Permute options' rawArgs

  let unknownOptionErrors =
       foldr (handleUnrecognizedOption . takeWhile (/= '=')) []
       unrecognizedOpts

  unless (null errors && null unknownOptionErrors) $
     E.throwIO $ PandocOptionError $ T.pack $
        concat errors ++ unlines unknownOptionErrors ++
        ("Try " ++ prg ++ " --help for more information.")

  -- thread option data structure through all supplied option actions
  opts <- foldl (>>=) (return defaults) actions
  let mbArgs = case args of
                 [] -> Nothing
                 xs -> Just xs
  return $ opts{ optStandalone = -- certain other options imply standalone
                   optStandalone opts ||
                     isJust (optTemplate opts) ||
                     optSelfContained opts ||
                     not (null (optIncludeInHeader opts)) ||
                     not (null (optIncludeBeforeBody opts)) ||
                     not (null (optIncludeAfterBody opts)) }


handleUnrecognizedOption :: String -> [String] -> [String]
handleUnrecognizedOption "--smart" =
  (("--smart/-S has been removed.  Use +smart or -smart extension instead.\n" ++
    "For example: pandoc -f markdown+smart -t markdown-smart.") :)
handleUnrecognizedOption "--normalize" =
  ("--normalize has been removed.  Normalization is now automatic." :)
handleUnrecognizedOption "-S" = handleUnrecognizedOption "--smart"
handleUnrecognizedOption "--old-dashes" =
  ("--old-dashes has been removed.  Use +old_dashes extension instead." :)
handleUnrecognizedOption "--no-wrap" =
  ("--no-wrap has been removed.  Use --wrap=none instead." :)
handleUnrecognizedOption "--latex-engine" =
  ("--latex-engine has been removed.  Use --pdf-engine instead." :)
handleUnrecognizedOption "--latex-engine-opt" =
  ("--latex-engine-opt has been removed.  Use --pdf-engine-opt instead." :)
handleUnrecognizedOption "--chapters" =
  ("--chapters has been removed. Use --top-level-division=chapter instead." :)
handleUnrecognizedOption "--reference-docx" =
  ("--reference-docx has been removed. Use --reference-doc instead." :)
handleUnrecognizedOption "--reference-odt" =
  ("--reference-odt has been removed. Use --reference-doc instead." :)
handleUnrecognizedOption "--parse-raw" =
  ("--parse-raw/-R has been removed. Use +raw_html or +raw_tex extension.\n" :)
handleUnrecognizedOption "--epub-stylesheet" =
  ("--epub-stylesheet has been removed. Use --css instead.\n" :)
handleUnrecognizedOption "-R" = handleUnrecognizedOption "--parse-raw"
handleUnrecognizedOption x =
  (("Unknown option " ++ x ++ ".") :)
