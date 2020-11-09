{-# LANGUAGE OverloadedStrings #-}

module Treedoc.Util
  ( formatFromFilePath
  , extensionFromFormat
  , saferListDirectory
  , saferReadFile
  , convertFileWithOpts
  , convertTextWithOpts
  , translateMarkupWithPandoc ) where

import qualified Text.Pandoc.App as P
import qualified Data.Text as T
import qualified Data.Char as C

import System.Directory
import System.IO
import System.FilePath
import System.IO.Temp

import Treedoc.Definition

-- Pure Code:

formatFromFilePath :: FilePath -> Maybe T.Text
formatFromFilePath path =
  case takeExtension (map C.toLower path) of
    ".adoc"     -> Just "asciidoc"
    ".asciidoc" -> Just "asciidoc"
    ".context"  -> Just "context"
    ".ctx"      -> Just "context"
    ".db"       -> Just "docbook"
    ".doc"      -> Just "doc"  -- so we get an "unknown reader" error
    ".docx"     -> Just "docx"
    ".dokuwiki" -> Just "dokuwiki"
    ".epub"     -> Just "epub"
    ".fb2"      -> Just "fb2"
    ".htm"      -> Just "html"
    ".html"     -> Just "html"
    ".icml"     -> Just "icml"
    ".json"     -> Just "json"
    ".latex"    -> Just "latex"
    ".lhs"      -> Just "markdown+lhs"
    ".ltx"      -> Just "latex"
    ".markdown" -> Just "markdown"
    ".md"       -> Just "markdown"
    ".ms"       -> Just "ms"
    ".muse"     -> Just "muse"
    ".native"   -> Just "native"
    ".odt"      -> Just "odt"
    ".opml"     -> Just "opml"
    ".org"      -> Just "org"
    ".pdf"      -> Just "pdf"  -- so we get an "unknown reader" error
    ".pptx"     -> Just "pptx"
    ".roff"     -> Just "ms"
    ".rst"      -> Just "rst"
    ".rtf"      -> Just "rtf"
    ".s5"       -> Just "s5"
    ".t2t"      -> Just "t2t"
    ".tei"      -> Just "tei"
    ".tei.xml"  -> Just "tei"
    ".tex"      -> Just "latex"
    ".texi"     -> Just "texinfo"
    ".texinfo"  -> Just "texinfo"
    ".text"     -> Just "markdown"
    ".textile"  -> Just "textile"
    ".txt"      -> Just "markdown"
    ".wiki"     -> Just "mediawiki"
    ".xhtml"    -> Just "html"
    ".ipynb"    -> Just "ipynb"
    ".csv"      -> Just "csv"
    ['.',y]     | y `elem` ['1'..'9'] -> Just "man"
    _           -> Nothing

extensionFromFormat :: Maybe T.Text -> FilePath
extensionFromFormat format =
  case format of
    Just "asciidoc"     ->                 ".adoc"
    Just "context"      ->                 ".ctx"
    Just "docbook"      ->                 ".db"
    Just "doc"          ->                 ".doc"
    Just "docx"         ->                 ".docx"
    Just "dokuwiki"     ->                 ".dokuwiki"
    Just "epub"         ->                 ".epub"
    Just "fb2"          ->                 ".fb2"
    Just "html"         ->                 ".html"
    Just "icml"         ->                 ".icml"
    Just "json"         ->                 ".json"
    Just "markdown+lhs" ->                 ".lhs"
    Just "markdown"     ->                 ".md"
    Just "ms"           ->                 ".ms"
    Just "muse"         ->                 ".muse"
    Just "native"       ->                 ".native"
    Just "odt"          ->                 ".odt"
    Just "opml"         ->                 ".opml"
    Just "org"          ->                 ".org"
    Just "pdf"          ->                 ".pdf"
    Just "pptx"         ->                 ".pptx"
    Just "rst"          ->                 ".rst"
    Just "rtf"          ->                 ".rtf"
    Just "s5"           ->                 ".s5"
    Just "t2t"          ->                 ".t2t"
    Just "tei"          ->                 ".tei"
    Just "latex"        ->                 ".tex"
    Just "texinfo"      ->                 ".texi"
    Just "textile"      ->                 ".textile"
    Just "mediawiki"    ->                 ".wiki"
    Just "ipynb"        ->                 ".ipynb"
    Just "csv"          ->                 ".csv"
    Just "man"          ->                 ".man?"
    Nothing             ->                 ""

-- Impure 

listDirectoryAbsolute :: FilePath -> IO [FilePath]
listDirectoryAbsolute path = do
    absPath <- makeAbsolute path
    files <- listDirectory absPath
    let absFiles = map (absPath</>) files
    return absFiles

saferListDirectory :: FilePath -> IO [FilePath]
saferListDirectory path =
  doesDirectoryExist path >>= (\x ->
                                  case x of
                                    True  -> listDirectoryAbsolute path
                                    False -> return [] )

convertFileWithOpts :: FilePath -> FilePath -> P.Opt -> IO ()
convertFileWithOpts input output opt = P.convertWithOpts $ opt { P.optInputFiles = Just [input]
                                                               , P.optOutputFile = Just output }

convertTextWithOpts :: T.Text -> FilePath -> P.Opt -> IO ()
convertTextWithOpts text output opt = do
  tempInputPath <- writeSystemTempFile "input.md" (T.unpack text)
  convertFileWithOpts tempInputPath output opt

translateMarkupWithPandoc :: T.Text -> P.Opt -> IO T.Text
translateMarkupWithPandoc text opt = do
  tempInputPath <- writeSystemTempFile "input.txt" (T.unpack text)
  tempOutputPath <- emptySystemTempFile "output.txt"
  convertFileWithOpts tempInputPath tempOutputPath opt
  T.pack <$> readFile tempOutputPath

saferReadFile :: FilePath -> IO (T.Text)
saferReadFile path =
  doesFileExist path >>= (\x ->
     case x of
       True  -> T.pack <$> (readFile path)
       False -> return T.empty )
