import Text.Nagato.Models
import Text.Nagato.Classify
import Text.Nagato.Query.IO
import Text.Nagato.Query.Trigram
import Text.Nagato.Query.Morphologic
import Text.Nagato.Query.Answer
import Text.Nagato.MeCabTools
import System.IO
import Data.Maybe

import Text.CSV

doTrainTrigram :: String -> IO (Probs (Trigram String))
doTrainTrigram sentence = do
  parts <- parseParts sentence
  let trigrams = trainTrigram parts
  return trigrams

main :: IO()
main = do
  print "todo: menu"

lTrain :: IO()
lTrain = do
  eitherLoaded <- parseCSVFromFile "setting.csv"
  case eitherLoaded of
    Left _ -> error "csv parse error"
    Right loaded -> do
      let (sentences, answers) = unzip $ map splitSetting loaded
      trained <- mapM doTrainTrigram $ sentences
      let model = zip answers trained
      writeModel "model.bin" model

lClassify :: IO()
lClassify = do
  model <- readModel "model.bin"
  line <- getLine 
  parts <- parseParts line
  wordsList <- parseWakati line
  let trigrams = makeTrigramList parts
  let ids = classify trigrams model
  putStrLnUtf8 $ concat $ map ((words wordsList) !!) $ fromJust ids

splitSetting :: [Field] -> (String, Answer)
splitSetting setting = (settingName setting, settingAnswer setting)

settingName :: [Field] -> String
settingName = head

settingAnswer :: [Field] -> [Int]
settingAnswer = (map read) . tail

putStrLnUtf8 :: String -> IO()
putStrLnUtf8 s = do
  let handle = stdout
  hSetEncoding handle utf8
  hPutStrLn handle s
