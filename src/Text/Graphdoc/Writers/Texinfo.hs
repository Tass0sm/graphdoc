module Text.Graphdoc.Writers.Texinfo
  ( writeWholeTexinfo ) where

import Text.Pandoc
import Text.Graphdoc.Definition
import System.Directory.Tree
import Data.Text as T
import Data.Tree

writeWholeTexinfo :: Graphdoc -> PandocIO (AnchoredDirTree T.Text)
writeWholeTexinfo (Graphdoc _ s) = do
  let content = mconcat $ nodeContent <$> flatten s
  text <- writeTexinfo def content
  let f = File "output.txt" text
  return ("." :/ f)
