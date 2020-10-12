module Treedoc.App.CommandLineOptions
  ( options
  , parseOptions ) where

import System.Environment
import System.Console.GetOpt
import Treedoc.App.Opt

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
     "FILE")
    -- And a description for the option.
    "Input Path"
  ]

parseOptions :: [OptDescr (Opt -> IO Opt)] -> Opt -> IO Opt
parseOptions optionDescriptions defaultOptions = do
  -- get every arg string
  args <- getArgs
  -- from every arg string, get a list of successfully parsed option
  -- transformations, unsuccessfully parsed options (left as strings), and error
  -- messages.
  let (actions, nonOpts, errors) = getOpt RequireOrder optionDescriptions args

  -- starting with a default options object, succesively apply every
  -- transformation. Start with defaults :: Opt. Lift that to IO Opt with
  -- return. Bind (>>=) The IO Opt into the current element of actions (Opt ->
  -- IO Opt). This returns an IO Opt, and repeat the process.
  foldl (>>=) (return defaultOptions) actions

  
