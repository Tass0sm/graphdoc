module Text.Graphdoc.Writers.Texinfo
  ( writeWholeTexinfo ) where

import Text.Pandoc
import Text.Graphdoc.Definition
import Text.Graphdoc.Class
import Control.Monad.IO.Class
import System.Directory.Tree
import Data.Text as T
import qualified Data.List as L
import Data.Tree
import Data.Maybe
import qualified Data.Graph.Inductive as FGL

import Text.Graphdoc.Graph.Utils

writeWholeTexinfo :: Graphdoc -> GraphdocIO (AnchoredDirTree T.Text)
writeWholeTexinfo (Graphdoc _ s) = do

  liftIO $ putStrLn $ drawTree $ show <$> nodeURL <$> getTree s

  let content = mconcat $ fmap nodeContent $ flatten $ getTree s
  text <- liftPandocIO $ writeTexinfo def content
  let f = File "output.txt" text
  return ("." :/ f)

getTree :: FGL.DynGraph gr => gr GraphdocNode GraphdocEdge -> Tree GraphdocNode
getTree g = let start = fromJust $ getTop g
            in orderedDFS' (transposeGraph g) start

getTop :: FGL.DynGraph gr => gr GraphdocNode GraphdocEdge -> Maybe FGL.Node
getTop g = do
  let goesToTop (_, _, e) = e == Top
  (_, t, _) <- L.find goesToTop (FGL.labEdges g)
  return t
