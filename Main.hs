import Text.Nagato.Models
import Text.Nagato.Query.IO
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
  eitherLoaded <- parseCSVFromFile "setting.csv"
  case eitherLoaded of
    Left _ -> error "hoge"
    Right loaded -> do
      let (sentences, answers) = unzip $ map splitSetting loaded
      trained <- mapM doTrainTrigram $ sentences
      let model = zip answers trained
      writeModel "model.bin" model

splitSetting :: [Field] -> (String, Answer)
splitSetting setting = (settingName setting, settingAnswer setting)

settingName :: [Field] -> String
settingName = head

settingAnswer :: [Field] -> [Int]
settingAnswer = (map read) . tail


