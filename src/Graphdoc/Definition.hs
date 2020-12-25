module Graphdoc.Definition
  ( DocFormat (..)
  , DocSection
  , DocGraph
  , DocRelation ) where

import Algebra.Graph.Labelled
import Data.Text (Text)

-- The types of tree recognized by treedoc.
data DocFormat = GenericMarkup | Texinfo
  deriving (Show, Read, Eq)

-- Documentation can be represented as a labelled, directed graph of
-- documentation sections. These sections can be seperate files, but it is
-- limiting to assume they always are. Other options at least include complete
-- bodies of text. So for now we will say:
data DocSection = File FilePath |
                  Body Text

type DocGraph = Graph String DocSection

-- For building a graph, one might need to get the relationship of each
-- DocSection. Sometimes, this relationship doesn't exist, so I use Maybe.
type DocRelation = DocSection -> Maybe DocSection

-- Another way 
