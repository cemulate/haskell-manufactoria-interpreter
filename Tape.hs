module Tape where

import Numeric
import Data.Char
import Text.Read

data TapeChar = Red | Blue | Green | Yellow deriving (Show, Eq)
type Tape = [TapeChar]

data TapeAction = None | Pop | Append TapeChar deriving (Show, Eq)

-- Performs a tape action on a tape
doAction :: TapeAction -> Tape -> Tape
doAction None t = t
doAction Pop (x:xs) = xs
doAction (Append x) t = t ++ [x]

-- Reading and printing

data TapeRepresentation = Color | Binary | Decimal deriving (Read, Show, Eq)

charToTapeChar :: Char -> Maybe TapeChar
charToTapeChar c
    | elem c "Bb" = Just Blue
    | elem c "Rr" = Just Red
    | elem c "Gg" = Just Green
    | elem c "Yy" = Just Yellow
    | otherwise   = Nothing

tapeCharToChar :: TapeChar -> Char
tapeCharToChar Red = 'R'
tapeCharToChar Blue = 'B'
tapeCharToChar Green = 'G'
tapeCharToChar Yellow = 'Y'

binToTapeChar :: Char -> Maybe TapeChar
binToTapeChar '0' = Just Red
binToTapeChar '1' = Just Blue
binToTapeChar _   = Nothing

tapeCharToBin :: TapeChar -> Maybe Int
tapeCharToBin Red = Just 0
tapeCharToBin Blue = Just 1
tapeCharToBin _ = Nothing

readTape :: TapeRepresentation -> String -> Maybe Tape
readTape m s = case m of
    Color -> mapM charToTapeChar $ s
    Binary -> mapM binToTapeChar $ s
    Decimal -> toBinString s >>= mapM binToTapeChar
    where
        toBinString x = showIntAtBase <$> pure 2 <*> pure intToDigit <*> (readMaybe x) <*> pure ""

printTape :: TapeRepresentation -> Tape -> Maybe String
printTape _ [] = Just ""
printTape m t = case m of
    Color -> Just (map tapeCharToChar t)
    Binary -> map intToDigit <$> mapM tapeCharToBin t
    Decimal -> show <$> fst <$> head <$> readInt 2 (flip elem "01") digitToInt <$> map intToDigit <$> mapM tapeCharToBin t
