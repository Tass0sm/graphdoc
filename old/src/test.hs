import Text.Pandoc
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import DocTree


someShit :: T.Text -> T.Text
someShit text = T.pack "new"

x = Node (T.pack "root",
          [Node (T.pack "node 1",
                 [Leaf $ T.pack "leaf 1",
                  Leaf $ T.pack "leaf 2"]),
           Node (T.pack "node 2",
                 [Leaf $ T.pack "leaf 3",
                  Leaf $ T.pack "leaf 4"])])

main :: IO ()
main = do
  result <- runIO $ do
    doc <- readMarkdown def (T.pack "[testing](https://youtube.com)")
    writeRST def doc
  rst <- handleError result
  TIO.putStrLn rst

-- ++ = append
-- : = cons
-- !! = get element
-- head = get the head (every list is a head : tail)
-- tail = get the tail
-- last = get the last item
-- init = everything except last item
-- length = get the length
-- null = check if list is null
-- reverse = return reversed list
-- take = return list of first n elements
-- drop = return list without first n elements
-- minimum/maximum = return the minimum / maximum
-- sum numbers
-- product numbers
-- elem = get element of list


-- Typeclasses (An abstraction of types, to which types belong.)
-- Eq = Supports equality tests
-- Ord = Supports ordering tests
-- Show = can be presented as a string
-- Read = can be parsed from a string
-- Enum = can be enumerated / used in a range. Succ and Pred
-- Bounded = has bounds
-- Num = can act like a number
-- Integral = can act like an integer
-- Floating = floating point numbers
-- comment
