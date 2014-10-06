import Text.Nagato.Models
import Text.Nagato.Query.Trigram
import Text.Nagato.Query.Morphologic
import Text.Nagato.Query.Answer

import Text.CSV

doTrainTrigram :: String -> IO (Probs (Trigram String))
doTrainTrigram sentence = do
  parts <- parseParts sentence
  let trigrams = trainTrigram parts
  return trigrams

main :: IO()
main = do
  loaded <- parseCSVFromFile "setting.csv"
  print loaded

splitSetting :: [String] -> (String, Answer)
splitSetting setting = (settingName setting, settingAnswer setting)

settingName :: [String] -> String
settingName = head

settingAnswer :: [String] -> [Int]
settingAnswer = (map read) . tail
