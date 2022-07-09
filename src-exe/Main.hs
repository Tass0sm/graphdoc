module Main where

import Data.Text.IO as TIO
import Data.Text as T
import Data.Tree
import Data.Either
import System.Directory.Tree
import System.Environment
import Text.Graphdoc
import Text.Pandoc (runIO)

rustBookPath :: String
rustBookPath = "/home/tassos/desktop/rust-book/"

main :: IO ()
main = do
  bookSource <- readDirectoryWith TIO.readFile rustBookPath

  texinfo <- runIO $ do
    book <- readBook bookSource
    writeWholeTexinfo book

  let (File _ t) = dirTree $ fromRight undefined $ texinfo
  TIO.putStrLn t

  -- writeDirectory texinfo
  -- let (Graphdoc _ tree) = fromRight undefined texinfo
  -- Prelude.putStrLn $ drawTree $ show <$> tree
