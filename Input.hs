module Input (parseProgram) where

import Data.List
import Data.Array

import Tape
import Cell
import Orientation
import Program

pad :: Char -> Int -> String -> String
pad c n s = s ++ (replicate diff c) where diff = max 0 (n - (length s))

padToRectangle :: String -> String
padToRectangle s = unlines . map (pad ' ' width) $ rows
    where
        rows = lines s
        width = maximum (map length rows)

build2DArray :: [[a]] -> Array (Int, Int) a
build2DArray arr = listArray ((0, 0), (width, height)) (concat . transpose $ arr)
    where
        width = length (head arr) - 1
        height = length arr - 1

makeCell :: Char -> Cell
makeCell c
    | elem c "!$;." = dfCell End
    | elem c "@0&"  = dfCell Start
    | c == '>'      = Cell Conveyor (Reg DRight)
    | c == '<'      = Cell Conveyor (Reg DLeft)
    | c == '^'      = Cell Conveyor (Reg DUp)
    | c == 'v'      = Cell Conveyor (Reg DDown)
    | c == '#'      = dfCell Bridge
    | c == ']'      = Cell CrossConveyor (Reg DDown)
    | c == '}'      = Cell CrossConveyor (Reg DRight)
    | c == '{'      = Cell CrossConveyor (Reg DUp)
    | c == '['      = Cell CrossConveyor (Reg DLeft)
    | c == 'r'      = Cell (Write Red) (Reg DRight)
    | c == 'c'      = Cell (Write Red) (Reg DUp)
    | c == 'R'      = Cell (Write Red) (Reg DLeft)
    | c == 'C'      = Cell (Write Red) (Reg DDown)
    | c == 'b'      = Cell (Write Blue) (Reg DRight)
    | c == 'd'      = Cell (Write Blue) (Reg DUp)
    | c == 'B'      = Cell (Write Blue) (Reg DLeft)
    | c == 'D'      = Cell (Write Blue) (Reg DDown)
    | c == 'g'      = Cell (Write Green) (Reg DRight)
    | c == 'q'      = Cell (Write Green) (Reg DUp)
    | c == 'G'      = Cell (Write Green) (Reg DLeft)
    | c == 'Q'      = Cell (Write Green) (Reg DDown)
    | c == 'y'      = Cell (Write Yellow) (Reg DRight)
    | c == 't'      = Cell (Write Yellow) (Reg DUp)
    | c == 'Y'      = Cell (Write Yellow) (Reg DLeft)
    | c == 'T'      = Cell (Write Yellow) (Reg DDown)
    | c == 'h'      = Cell (Branch BR) (Mir DLeft)
    | c == 'j'      = Cell (Branch BR) (Mir DDown)
    | c == 'k'      = Cell (Branch BR) (Mir DUp)
    | c == 'l'      = Cell (Branch BR) (Mir DRight)
    | c == 'H'      = Cell (Branch BR) (Reg DLeft)
    | c == 'J'      = Cell (Branch BR) (Reg DDown)
    | c == 'K'      = Cell (Branch BR) (Reg DUp)
    | c == 'L'      = Cell (Branch BR) (Reg DRight)
    | c == 'u'      = Cell (Branch GY) (Reg DLeft)
    | c == 'i'      = Cell (Branch GY) (Reg DDown)
    | c == 'o'      = Cell (Branch GY) (Reg DUp)
    | c == 'p'      = Cell (Branch GY) (Reg DRight)
    | c == 'U'      = Cell (Branch GY) (Mir DLeft)
    | c == 'I'      = Cell (Branch GY) (Mir DDown)
    | c == 'O'      = Cell (Branch GY) (Mir DUp)
    | c == 'P'      = Cell (Branch GY) (Mir DRight)
    | otherwise    = dfCell Empty

parseProgram :: String -> MProgram
parseProgram raw = build2DArray . map (map makeCell) $ arr where arr = lines . padToRectangle $ raw
