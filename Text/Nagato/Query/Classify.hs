module Text.Nagato.Query.Classify
(tune
)
where
import Text.Nagato.MeCabTools()
import Data.List
import Data.Maybe

tune :: [String] -> Int -> String -> Int  
tune parts pos part 
  | parts !! pos == part = pos 
  | otherwise = nearest pos (elemIndices part parts)

-- Returns distance for idx
near :: Int -> [Int] -> [Int]  
near pos indices = map (abs . subtract pos) indices

nearest :: Int -> [Int] -> Int
nearest pos indices = indices !! (fromJust (elemIndex (minimum (near pos indices)) (near pos indices)))

