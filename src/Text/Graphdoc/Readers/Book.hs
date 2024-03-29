module Text.Graphdoc.Readers.Book
  ( readBook ) where

import Text.Graphdoc.Class
import Text.Graphdoc.Definition
import Text.Graphdoc.Parsing
import Control.Monad.Reader
import System.Directory.Tree
import System.FilePath
import Text.Parsec
import Text.Pandoc.Class
import Text.Pandoc
import Text.Pandoc.Shared
import Text.Graphdoc.Utils
import Data.Functor.Compose
import Data.Either
import Data.Maybe
import Data.Text as T
import Data.Text.IO as TIO
import Data.Tree

readBook :: GraphSource -> GraphdocIO Graphdoc
readBook tree = do
  let summaryFileText = fromMaybe (T.pack "") $ findByPath "./src/SUMMARY.md" tree
  doc <- liftPandocIO $ readMarkdown def summaryFileText
  emptyStructure <- parseSummaryDoc doc
  fullStructure <- undefined -- traverse fillContent emptyStructure
  return $ Graphdoc mempty fullStructure

fillContent :: GraphdocNode -> GraphdocIO GraphdocNode
fillContent node = if T.null $ nodeURL node
  then return node
  else liftPandocIO $ do
  text <- liftIO $ TIO.readFile $ T.unpack $ nodeURL node
  content <- readMarkdown def text
  return $ node { nodeContent = content }

parseSummaryDoc :: Pandoc -> GraphdocIO (Tree GraphdocNode)
parseSummaryDoc (Pandoc _ blocks) = liftParserEither $ parse summaryFile "SUMMARY.md" blocks

summaryFile :: BlockParser (Tree GraphdocNode)
summaryFile = do
  t <- option (GraphdocNode (Title mempty) mempty mempty) title

  prefixChapters <- option [] unnumberedChapters
  parts <- many part
  suffixChapters <- option [] unnumberedChapters

  let cs = ((flip Node []) <$> prefixChapters) ++ parts ++ ((flip Node []) <$> suffixChapters)
  return $ Node t cs

title :: BlockParser GraphdocNode
title = do
  (Header _ _ ils) <- header 1
  let t = stringify ils
  return $ GraphdocNode (Title t) mempty (T.pack "")

part :: BlockParser (Tree GraphdocNode)
part = do
  title <- partTitle
  forest <- chapterForest
  return $ Node title forest

partTitle :: BlockParser (GraphdocNode)
partTitle = do
  (Header _ _ ils) <- block "Header"
  return $ GraphdocNode
    { nodeType = PartTitle $ stringify ils
    , nodeContent = mempty
    , nodeURL = mempty
    }

chapterForest :: BlockParser (Forest GraphdocNode)
chapterForest = do
  forest <- bulletList
  let traversableForest = Compose { getCompose = forest }
  getCompose <$> traverseParser traversableForest blockChapter

unnumberedChapters :: BlockParser [GraphdocNode]
unnumberedChapters = liftInlineParser $ many $ do
  c <- inlineChapter
  optional softbreak
  return c

blockChapter :: BlockParser GraphdocNode
blockChapter = liftInlineParser inlineChapter

-- temp
root :: T.Text
root = T.pack "/home/tassos/desktop/rust-book/src/"

inlineChapter :: InlineParser GraphdocNode
inlineChapter = do
  (Link _ ils (url, _)) <- inline "Link"
  let t = stringify ils
  return $ GraphdocNode (Chapter 1 t) mempty (root <> url)
