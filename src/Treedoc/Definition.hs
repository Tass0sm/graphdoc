module Treedoc.Definition
  ( DocSource
  , DocTree ) where

import Data.Text
import Data.Tree

-- Pure Code:

type DocSource = (String, Text)
type DocTree = Tree DocSource

-- Impure Code:
