module Text.Graphdoc.Class.GraphdocMonad
  ( GraphdocMonad(..) ) where

import Text.Graphdoc.Definition
import Control.Monad.Reader

-- | The GraphdocMonad typeclass specifies the interface for the state involved
-- in a graphdoc computation.
class GraphdocMonad m where
  -- | Get the graphdoc associated with this graphdoc computation.
  getGraphdoc :: m Graphdoc
