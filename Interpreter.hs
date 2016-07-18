module Interpreter where

import Data.List
import Data.Array
import Control.Monad
import Control.Monad.State.Lazy

import Tape
import Orientation
import Cell
import Program

data MState = MState { tape :: Tape, pos :: (Int, Int), facing :: Direction } deriving (Show, Eq)

data MResult = MResult { accepted :: Bool, finalTape :: Tape } deriving (Show, Eq)

initState :: Tape -> MProgram -> Maybe MState
initState t p = MState <$> pure t <*> pos <*> pure DRight
    where
        pos = fmap fst . find (\(_, c) -> (cellType c) == Start) $ assocs p

branch :: TapeChar -> Cell -> (Direction, TapeAction)
branch tHead (Cell t o) = case t of
    (Branch BR) -> if (tHead == Blue || tHead == Red) then (turnTo tHead $ dir o, Pop) else (dir o, None)       -- If blue or red, face appropriate way and pop; otherwise, face neutral and do nothing
    (Branch GY) -> if (tHead == Green || tHead == Yellow) then (turnTo tHead $ dir o, Pop) else (dir o, None)   -- If green or yellow, face appropriate way and pop; otherwise, face neutral and do nothing
    where
        turnTo Red = if (isMir o) then turnCCW else turnCW     -- Turn clockwise to get to red terminal, but if mirrored, turn counterclockwise
        turnTo Green = if (isMir o) then turnCCW else turnCW   -- Turn clockwise to get to green terminal, but if mirrored, turn counterclockwise
        turnTo Blue = if (isMir o) then turnCW else turnCCW    -- Turn counterclockwise to get to blue terminal, but if mirrored, turn clockwise
        turnTo Yellow = if (isMir o) then turnCW else turnCCW  -- Turn counterclockwise to get to yellow terminal, but if mirrored, turn clockwise

evalCell :: Cell -> Maybe TapeChar -> Direction -> (Direction, TapeAction)
evalCell c@(Cell t o) tHead facing = case t of
    Start -> (DDown, None)           -- Face down on start; do nothing to tape
    Conveyor -> (dir o, None)        -- Face conveyor direction; do nothing to tape
    CrossConveyor -> (facing, None)  -- Face same direction; do nothing to tape
    (Branch _) -> case tHead of
        Nothing -> (dir o, None)     -- Tape is empty, face neutral direction; do nothing to tape
        (Just v) -> branch v c       -- Tape has a head, pass to branch logic
    (Write x) -> (dir o, Append x)   -- Face writer direction; append value


evalProgram :: MProgram -> (State MState) MResult
evalProgram p = do
    (MState tape pos facing) <- get

    let cell = p ! pos
    let mhead = if (null tape) then Nothing else Just (head tape)
    let (newFacing, action) = evalCell cell mhead facing
    let newPos = moveDir newFacing pos
    let newTape = doAction action tape

    put (MState newTape newPos newFacing)

    if (inRange (bounds p) newPos)
        then do
            let (Cell t _) = p ! newPos
            case t of
                Start -> return (MResult False newTape)
                Empty -> return (MResult False newTape)
                End -> return (MResult True newTape)
                _ -> evalProgram p
        else do
            return (MResult False newTape)

runProgram :: Tape -> MProgram -> Maybe MResult
runProgram t p = evalState <$> pure (evalProgram p) <*> (initState t p)
