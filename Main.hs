import Text.Nagato.Models
import Text.Nagato.Train

type Trigram a = (a, a, a)

makeTrigramList :: [a] -> [Trigram a]
makeTrigramList [a, b, c] = [(a, b, c)]
makeTrigramList al@(a:b:c:_) = (a, b, c) : (makeTrigramList(tail al))

trainTrigram ::(Ord a) => [a] -> Probs (Trigram a)
trainTrigram = trainClass . makeTrigramList
