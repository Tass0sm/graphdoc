module Treedoc.Class.TreedocReadable
  ( TreedocReadable(..) ) where

class TreedocReadable a where
  -- | Read an 'a' from some path.
  read :: FilePath -> PandocIO a
