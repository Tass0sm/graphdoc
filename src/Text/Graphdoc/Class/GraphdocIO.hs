{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Text.Graphdoc.Class.GraphdocIO
  ( GraphdocIO(..)
  , runGraphdocIO
  , liftPandocIO
  , liftPandocEither
  , liftParserEither
  ) where

import Text.Graphdoc.Class.GraphdocMonad
import Text.Graphdoc.Definition
import Text.Graphdoc.Error
import Text.Pandoc.Class as P
import Text.Pandoc.Error
import Text.Parsec.Error
import Control.Monad.Reader
import Control.Monad.Except

newtype GraphdocIO a = GraphdocIO {
  unGraphdocIO :: ExceptT GraphdocError P.PandocIO a
  } deriving ( Functor
             , Applicative
             , Monad
             , MonadError GraphdocError)

-- | Evaluate a 'GraphdocIO' operation.
runGraphdocIO :: GraphdocIO a -> IO (Either GraphdocError a)
runGraphdocIO g = do
  r <- P.runIO $ runExceptT $ unGraphdocIO g
  return $ case r of
    Left e -> Left $ GraphdocPandocError e
    Right x -> x

liftPandocEither :: Either PandocError a -> GraphdocIO a
liftPandocEither = either (throwError . GraphdocPandocError) return

liftParserEither :: Either ParseError a -> GraphdocIO a
liftParserEither = either (throwError . GraphdocParserError) return

liftPandocIO :: PandocIO a -> GraphdocIO a
liftPandocIO p =
  GraphdocIO $ lift $ p


-- instance MonadReader Graphdoc GraphdocIO where
--   ask = GraphdocIO ask
--   local f = GraphdocIO . local f . unGraphdocIO

-- instance GraphdocMonad GraphdocIO where
--   getGraphdoc = ask
