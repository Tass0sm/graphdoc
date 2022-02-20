module Graphdoc.Analysis.Book
  ( analyzeBook ) where

import Text.Pandoc

import qualified Graphdoc.Definition as GD
import Data.Tree
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

import Text.Parsec
import Text.Parsec.Prim
import Graphdoc.Parsing

analyzeBook :: FilePath -> IO ()
analyzeBook file = do
  text <- TIO.readFile file
  result <- runIO $ readMarkdown def text
  (Pandoc _ bs) <- handleError result
  let s = case (parse summaryFile "name" bs) of
                    Left err -> show err
                    Right a -> drawTree a
  putStrLn s

-- Parsing Summary File

-- summary-file <- title [prefix-chapter] [part] [suffix-chapters]
-- title <- TITLE
-- prefix-chapter <- LINK
-- part <- LINK

summaryFile :: Parsec [Block] () (Tree String)
summaryFile = do
  t <- option "top" title
  block "Para"
  header 2
  tree <- bulletList
  return $ show <$> tree
--  b <- prefixChapters
--  m <- parts
--  e <- suffixChapters
--  return $ Node t (b ++ m ++ e)

title = do
  (Header _ _ s) <- header 1
  return $ show s

prefixChapters = do
  block "Para"

suffixChapters = many chapter
parts = many part

part :: Parsec [Block] () (Tree String)
part = do
  tree <- bulletList
  return $ getLink <$> tree
    where getLink = undefined

chapter :: Parsec [Block] () (Tree String)
chapter = undefined
