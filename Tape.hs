module Tape where

data TapeChar = Red | Blue | Green | Yellow deriving (Show, Eq)
type Tape = [TapeChar]

data TapeAction = None | Pop | Append TapeChar deriving (Show, Eq)

-- Performs a tape action on a tape
doAction :: TapeAction -> Tape -> Tape
doAction None t = t
doAction Pop (x:xs) = xs
doAction (Append x) t = t ++ [x]
