module Treedoc.Definition
  ( DocSource
  , DocTree ) where

import Data.Text
import Data.Tree

type DocSource = (String, Text)
type DocTree = Tree DocSource

-- Pure Code:

-- Impure Code:
