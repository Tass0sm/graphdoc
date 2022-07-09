{-# LANGUAGE MultiParamTypeClasses #-}

module Text.Graphdoc.Class.GraphdocIO
  ( GraphdocIO(..)
  -- , runGraphdocIO
  ) where

import Text.Graphdoc.Class.GraphdocMonad
import Text.Graphdoc.Definition
import Text.Pandoc.Class as P
import Text.Pandoc.Error
import Control.Monad.Reader

-- | Evaluate a 'GraphdocIO' operation.
-- runGraphdocIO :: Graphdoc -> GraphdocIO a -> IO (Either PandocError a)
-- runGraphdocIO g ma = P.runIO $ flip runReaderT g ma

newtype GraphdocIO a = GraphdocIO {
  unGraphdocIO :: ReaderT Graphdoc P.PandocIO a
  }

instance Functor GraphdocIO where
  fmap f = GraphdocIO . fmap f . unGraphdocIO

instance Applicative GraphdocIO where
  pure = GraphdocIO . pure
  f <*> x = GraphdocIO $ (unGraphdocIO f) <*> (unGraphdocIO x)

instance Monad GraphdocIO where
  x >>= f = GraphdocIO $ (unGraphdocIO x) >>= (unGraphdocIO . f)

instance MonadReader Graphdoc GraphdocIO where
  ask = GraphdocIO ask
  local f = GraphdocIO . local f . unGraphdocIO

instance GraphdocMonad GraphdocIO where
  getGraphdoc = ask
