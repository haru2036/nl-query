module  Text.Nagato.Query.IO where

import Text.Nagato.Query.Trigram
import Text.Nagato.Models
import Data.Either.Unwrap
import Data.Serialize
import Data.ByteString as BS

writeModel :: FilePath -> [([Int], Probs (Trigram String))] -> IO()
writeModel filePath model = do
  let bytes = encode model
  BS.writeFile filePath bytes
  
readModel :: FilePath -> IO [([Int], Probs (Trigram String))]
readModel filePath = do 
  bytes <- BS.readFile filePath
  let decoded = decode bytes :: Either String [([Int], Probs (Trigram String))]
  return $ fromRight decoded
