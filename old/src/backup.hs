module DocTree
  ( DocTree (..)
  , mapToNodes
  , mapToLeaves
  , subTree
  , setTreeRoot
  ) where

-- Import Text and Associated Functions
import qualified Data.Text as T

-- Import System.FilePath
import System.FilePath (FilePath)

-- Import Bool
import Data.Bool

-- DocTree. Tree of documentation source text.
data DocTree = Leaf T.Text | Node (T.Text, [DocTree])
  deriving (Show)

-- mapToNodes. Maps a text transforming function to every node in a tree.
mapToNodes :: (T.Text -> T.Text) -> DocTree -> DocTree
mapToNodes func (Leaf text) = Leaf $ func text
mapToNodes func (Node (text, children)) =
  Node (func $ text, map (mapToNodes func) children)

-- mapToLeaves. Maps a text transforming function to every leaf in a tree.
mapToLeaves :: (T.Text -> T.Text) -> DocTree -> DocTree
mapToLeaves func (Leaf text) = Leaf $ func text
mapToLeaves func (Node (text, children)) =
  Node (text, map (mapToLeaves func) children)

-- subTree. Gets the child-th subtree of the DocTree, unless the tree has no
-- children. It just returns the tree in that case.
subTree :: Int -> DocTree -> DocTree
subTree child (Node (_, children)) = children !! child
subTree _ leaf = leaf

-- setTreeRoot. Sets the text of the tree's root.
setTreeRoot :: T.Text -> DocTree -> DocTree
setTreeRoot text (Node (_, children)) = Node (text, children)
setTreeRoot text _ = Leaf text

-- checkChild. Checks if child of tree is present.
checkChild :: Int -> DocTree -> Bool
checkChild child (Node (_, children)) = child < length children
checkChild child _ = False

-- fillTreeList. Pads the list of trees until the length requirement is
-- satisfied.
fillTreeList :: Int -> [DocTree] -> [DocTree]
fillTreeList len list =
  if length list < len
  then fillTreeList len (list ++ [Leaf $ T.pack "tmp"])
  else list

-- fillChildren. Pads the children list of the tree until the length requirement
-- is satisfied.
fillChildren :: Int -> DocTree -> DocTree
fillChildren len (Node (text, children)) =
  let filledChildren = fillTreeList len children in
    Node (text, filledChildren)
fillChildren len (Leaf text) =
  let filledChildren = fillTreeList len [] in
    Node (text, filledChildren)

modifyNth :: Eq a => Int -> (a -> a) -> [a] -> [a]
modifyNth index func list =
  let correct = list !! index in
    map (\x -> if (x == correct)
               then func x
               else x) list

-- treeindex. [] corresponds to root, [n] corresponds to nth child of root,
-- [n,m] corresponds to mth child of nth child of root, and so on.
type TreeIndex = [Int]

setOrCreateNode :: TreeIndex -> T.Text -> DocTree -> DocTree
setOrCreateNode (child:rest) text (Node (old, children)) =
  let paddedChildren = fillTreeList (child + 1) children
      finalChildren = modifyNth child (\x -> setOrCreateNode rest text x) paddedChildren
  in Node (old, finalChildren)
setOrCreateNode [] text (Node (old, children)) =
  Node (text, children)
setOrCreateNode [] text (Leaf old) =
  Leaf text

-- setTreeNode :: T.Text -> TreeIndex -> DocTree -> DocTree
-- setTreeNode text child:rest (Node (_, children)) = Node (text, children)
-- setTreeNode text _ = Leaf text


-- setOrCreateNode child:other text Node (_, children) =
--
--   if checkChild child tree
--   then setOrCreateNode other text (children !! child)
--   else children
--
--   let subtree = subTree child tree in
--     setOrCreateNode other text subtree
-- setOrCreateNode [] text tree =

getTreeIndex :: FilePath -> TreeIndex
getTreeIndex file = [1, 1]

getTreeIndicies :: [FilePath] -> [TreeIndex]
getTreeIndicies files = map getTreeIndex files
