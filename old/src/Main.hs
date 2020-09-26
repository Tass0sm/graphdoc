import System.Directory (listDirectory)
import qualified Data.Text as T
import DocTree

x = Node (T.pack "root",
          [Node (T.pack "node 1",
                 [Leaf $ T.pack "leaf 1",
                  Leaf $ T.pack "leaf 2"]),
           Node (T.pack "node 2",
                 [Leaf $ T.pack "leaf 3",
                  Leaf $ T.pack "leaf 4"])])

main :: IO()
main = do
  list <- listDirectory "."
  putStrLn $ show list
