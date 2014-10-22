module Text.Nagato.Query.Classify
(tune
)
where
import Text.Nagato.MeCabTools()
import Data.List

tune :: [String] -> Int -> String -> Int  
tune parts pos part = nearest pos (elemIndices part parts)

near :: Int -> [Int] -> [Int]
near pos indices = map (abs . subtract pos) indices

nearest :: Int -> [Int] -> Int
nearest pos indices = indices !! ((minimum (near pos indices))) 
