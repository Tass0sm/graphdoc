module Graphdoc.Conversion.Util
    ( convertToIRGraph
    , mapOverNodes
    ) where

import qualified Data.Text.IO as TIO
import Data.Text

import Graphdoc.Definition
import Text.Pandoc.Definition

convertToIRNode :: DocNode -> (Text -> Pandoc) -> IO DocNode
convertToIRNode (DocNode m (File f)) converter = do
  t <- TIO.readFile f
  let p = converter t
  return $ DocNode m (Doc p)
convertToIRNode (DocNode m (Body t)) converter =
  let p = converter t
  in return $ DocNode m (Doc p)
convertToIRNode n _ = return n

convertToContentGraph :: DocGraph -> DocGraph
convertToContentGraph = undefined

convertToIRGraph :: DocGraph -> DocGraph
convertToIRGraph = undefined


mapOverNodes = undefined
