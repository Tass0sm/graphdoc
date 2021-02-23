{-# LANGUAGE OverloadedStrings #-}

module Graphdoc.Analysis.HTML.Links 
  ( getNamedLinks ) where

import qualified Data.Text as T
import Text.HTML.TagSoup

isLink :: Tag T.Text -> Bool
isLink (TagOpen txt attrList) = txt == "LINK"
isLink _ = False

getHTMLLinks :: [Tag T.Text] -> [Tag T.Text]
getHTMLLinks tags = filter isLink tags

linkNames :: [String]
linkNames = [ "NEXT"
            , "PREV"
            , "UP"
            , "TOP" ]

getNamedLinks :: T.Text -> [(String, String)]
getNamedLinks src =
  let linkTags = getHTMLLinks $ parseTags src
      names = map (T.unpack . fromAttrib "REL") linkTags
      links = map (T.unpack . fromAttrib "HREF") linkTags
      pairs = zip names links
      isValidName = \n -> elem n linkNames
      hasValidRel = isValidName . fst
  in filter hasValidRel pairs
