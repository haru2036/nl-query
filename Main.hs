import Text.Nagato.Query.Trigram
import Text.Nagato.Query.Morphologic


makePartsTrigram :: String -> IO [Trigram String]
makePartsTrigram sentence = do
  parts <- parseParts sentence
  return $ makeTrigramList parts


