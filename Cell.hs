module Cell where

import Tape
import Orientation

data BranchType = BR | GY deriving (Show, Eq)
data CellType = Empty | Start | End | Conveyor | CrossConveyor | Branch BranchType | Write TapeChar deriving (Show, Eq)

data Cell = Cell { cellType :: CellType, orientation :: Orientation} deriving (Show, Eq)

-- Makes a cell with orientation (Reg Down)
dfCell :: CellType -> Cell
dfCell t = Cell t (Reg DDown)
