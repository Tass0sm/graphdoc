module Graphdoc.Analysis.CLI
  ( options
  , parseOptionsFromArgs
  , parseOptions ) where

import Data.Char (toLower)

import System.Environment
import System.Console.GetOpt

import Graphdoc.Definition
import Graphdoc.Analysis.Opt

-- A list of option descriptions. The argument to the OptDescr type "(Opt -> IO
-- Opt)" means that for each flag, an argument might be taken and return a
-- function transforming some input set of options to an updated set of options,
-- through some IO action.
options :: [OptDescr (Opt -> IO Opt)]
options =
  -- The first option, constructed with "Option".
  [ Option "i" ["input"] --the option corresponding to the flags "-i" or "--input"
    (ReqArg
     -- ReqArg takes some (String -> a). a is (Opt -> IO Opt), so we need to
     -- give (String -> Opt -> IO Opt).
     (\arg opt -> return opt {optInputPath = Just arg})
     -- ReqArg also takes an extra string for some reason?
     "PATH")
    -- And a description for the option.
    "Input Path"
  , Option "o" ["output"]
    (ReqArg
     (\arg opt -> return opt {optOutputPath = Just arg})
     "PATH")
    "Output Path"
  , Option "f" ["from", "format"]
    (ReqArg
     (\arg opt -> return opt {optFormat = (read arg)::DocFormat})
     "PATH")
    "Input Tree Format"
  ]

totalParseArgs :: [String] -> [OptDescr (Opt -> IO Opt)] -> Opt -> IO Opt
totalParseArgs args optionDescriptions defaultOptions = do
  -- from every arg string, get a list of successfully parsed option
  -- transformations, unsuccessfully parsed options (left as strings), and error
  -- messages.
  let (actions, nonOpts, unrecognizedOpts, errors) = getOpt' Permute optionDescriptions args

  let mbInput = case nonOpts of
                  [] -> Nothing
                  x:_ -> Just x
  
  -- starting with a default options object, succesively apply every
  -- transformation. Start with defaults :: Opt. Lift that to IO Opt with
  -- return. Bind (>>=) The IO Opt into the current element of actions (Opt ->
  -- IO Opt). This returns an IO Opt, and repeat the process.
  optWithoutInput <- foldl (>>=) (return defaultOptions) actions
  let opt = optWithoutInput { optInputPath = mbInput }
  return opt

parseOptionsFromArgs :: [String] -> IO Opt
parseOptionsFromArgs args = do
  totalParseArgs args options defaultOpts
  
parseOptions :: IO Opt
parseOptions = do
  args <- getArgs
  parseOptionsFromArgs args


