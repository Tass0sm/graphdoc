{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Output.Util
    ( docNodeContent
    , hPutDocNodes
    ) where

import Graphdoc.Definition

import Data.Text
import qualified Data.Text.IO as TIO
import System.IO

docNodeContent :: DocNode -> Text
docNodeContent (DocNode _ (Body t)) = t
docNodeContent _ = ""

hPutDocNodes :: Handle -> [DocNode] -> IO ()
hPutDocNodes handle nodeList =
  mapM_ (TIO.hPutStr handle . docNodeContent) nodeList
