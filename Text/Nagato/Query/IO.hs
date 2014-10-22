module  Text.Nagato.Query.IO where

import Text.Nagato.Query.Trigram
import Text.Nagato.Query.Answer
import Text.Nagato.Models
import Data.Either.Unwrap
import Data.Serialize
import Data.ByteString as BS

type Model = [(Answer, Probs (Trigram String))]

writeModel :: FilePath -> Model -> IO()
writeModel filePath model = do
  let bytes = encode model
  BS.writeFile filePath bytes
  
readModel :: FilePath -> IO Model
readModel filePath = do 
  bytes <- BS.readFile filePath
  let decoded = decode bytes :: Either String Model
  return $ fromRight decoded
