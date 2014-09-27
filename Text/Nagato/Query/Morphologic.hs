module Text.Nagato.Query.Morphologic
(parseParts 
)where

import Text.MeCab
import Text.Nagato.MeCabTools 

parseParts :: String -> IO [String]
parseParts sentence = do
  mecab <- new2 ""
  parsed <- parse mecab sentence
  return (map part (init (lines parsed)))

part :: String -> String
part = head . splitOnConma . (!! 1) . splitOnTab
