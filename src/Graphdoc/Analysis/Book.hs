module Graphdoc.Analysis.Book
  ( analyzeBook
  , parseSummaryFile ) where

import Text.Pandoc

import qualified Graphdoc.Definition as GD
import Data.Tree
import qualified Data.Text.IO as TIO

analyzeBook :: GD.Reader
analyzeBook dir = undefined

parseSummaryFile :: FilePath -> IO ()
parseSummaryFile path = do
  text <- TIO.readFile path
  result <- runIO $ readMarkdown def text
  doc <- handleError result


  putStrLn $ show doc
