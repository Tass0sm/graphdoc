module Graphdoc.Class.GraphdocMonad
  ( GraphdocMonad(..) ) where

class (Functor m, Applicative m, Monad m, MonadError PandocError m)
      => GraphdocMonad m where
