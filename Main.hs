import Text.Nagato.Models
import Text.Nagato.Classify
import Text.Nagato.Query.IO
import Text.Nagato.Query.Trigram
import Text.Nagato.Query.Morphologic
import Text.Nagato.Query.Answer
import Text.Nagato.Query.Classify
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
      answers <- mapM addParts loaded
      let sentences = map settingName loaded
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
  putStrLnUtf8 $ unwords $ map (\(idx,part) -> (words wordsList) !! ((tune parts idx part))) $ fromJust ids

splitSetting :: [Field] -> (String, [Int])
splitSetting setting = (settingName setting, settingAnswer setting)

settingName :: [Field] -> String
settingName = head

settingAnswer :: [Field] -> [Int]
settingAnswer = (map read) . tail

addParts :: [Field] -> IO Answer
addParts fields = do
  parts <- parseParts $ settingName fields
  return $ map (\x -> (x, parts !! x)) $ settingAnswer fields

putStrLnUtf8 :: String -> IO()
putStrLnUtf8 s = do
  let handle = stdout
  hSetEncoding handle utf8
  hPutStrLn handle s
