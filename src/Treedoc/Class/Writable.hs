module Treedoc.Class.TreedocWritable
  ( TreedocWritable(..) ) where

class TreedocWritable a where
  -- | Write an 'a' at the given path.
  write :: WriterOptions -> a -> FilePath -> IO ()
