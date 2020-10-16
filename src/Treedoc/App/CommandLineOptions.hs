module Treedoc.App.CommandLineOptions
  ( options
  , parseOptionsFromArgs
  , parseOptions ) where

import System.Environment
import System.Console.GetOpt
import Treedoc.App.Opt
import Treedoc.Definition

-- A list of option descriptions. The argument to the OptDescr type "(Opt -> IO
-- Opt)" means that for each flag, an argument might be taken and return a
-- function transforming some input set of options to an updated set of options,
-- through some IO action.
options :: [OptDescr (Opt -> IO Opt)]
options =
  -- The first option, constructed with "Option".
  [ Option "" ["tree-input"] --the option corresponding to the flags "-i" or "--input"
    (ReqArg
     -- ReqArg takes some (String -> a). a is (Opt -> IO Opt), so we need to
     -- give (String -> Opt -> IO Opt).
     (\arg opt -> return opt {optInputPath = Just arg})
     -- ReqArg also takes an extra string for some reason?
     "PATH")
    -- And a description for the option.
    "Input Path"
  , Option "" ["tree-output"]
    (ReqArg
     (\arg opt -> return opt {optOutputPath = Just arg})
     "PATH")
    "Output Path"
  , Option "" ["tree-from"]
    (ReqArg
     (\arg opt -> return opt {optFrom = (read arg)::Format})
     "PATH")
    "Input Tree Format"
  , Option "" ["tree-to"]
    (ReqArg
     (\arg opt -> return opt {optTo = (read arg)::Format})
     "PATH")
    "Output Tree Format"
  ]

parseOptionsFromArgs :: [String] -> [OptDescr (Opt -> IO Opt)] -> Opt -> IO (Opt, [String])
parseOptionsFromArgs args optionDescriptions defaultOptions = do
  -- from every arg string, get a list of successfully parsed option
  -- transformations, unsuccessfully parsed options (left as strings), and error
  -- messages.
  let (actions, nonOpts, unrecognizedOpts, errors) = getOpt' Permute optionDescriptions args

  -- starting with a default options object, succesively apply every
  -- transformation. Start with defaults :: Opt. Lift that to IO Opt with
  -- return. Bind (>>=) The IO Opt into the current element of actions (Opt ->
  -- IO Opt). This returns an IO Opt, and repeat the process.
  opt <- foldl (>>=) (return defaultOptions) actions
  return (opt, unrecognizedOpts)
  
parseOptions :: [OptDescr (Opt -> IO Opt)] -> Opt -> IO Opt
parseOptions optionDescriptions defaultOptions = do
  args <- getArgs
  pair <- parseOptionsFromArgs args optionDescriptions defaultOptions
  return (fst pair)

