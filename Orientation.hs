module Orientation where

data Direction = DUp | DRight | DDown | DLeft deriving (Show, Eq)
data Orientation = Reg { dir :: Direction } | Mir { dir :: Direction } deriving (Show, Eq)

isMir :: Orientation -> Bool
isMir (Reg _) = False
isMir (Mir _) = True

-- Returns the next clockwise facing direction (90 degree increments)
turnCW :: Direction -> Direction
turnCW DLeft = DUp
turnCW DUp = DRight
turnCW DRight = DDown
turnCW DDown = DLeft

-- Turn counter clockwise (== clockwise 3 times)
turnCCW :: Direction -> Direction
turnCCW = turnCW . turnCW . turnCW

-- Turn around (== clockwise twice)
turnOpp :: Direction -> Direction
turnOpp = turnCW . turnCW

-- Adjust indices by moving in a direction
moveDir :: Direction -> (Int, Int) -> (Int, Int)
moveDir DLeft (x,y) = (x-1, y)
moveDir DUp (x,y) = (x, y-1)
moveDir DRight (x,y) = (x+1, y)
moveDir DDown (x,y) = (x, y+1)
