module Program where

import Tape
import Orientation
import Cell
import Data.Array

type MProgram = Array (Int, Int) Cell

defaultProgram :: Int -> MProgram
defaultProgram n = array ((0, 0), (lst, lst)) [((i, j), gen i j) | i <- [0..lst], j <- [0..lst]]
    where
        lst = n-1
        cx = n `quot` 2
        gen i j
            | (i == cx) && (j == 0)     = dfCell Start
            | (i == cx) && (j == (n-1)) = dfCell End
            | otherwise                 = dfCell Empty

place :: (Int, Int) -> Cell -> MProgram -> MProgram
place loc c p = p // [(loc, c)]
