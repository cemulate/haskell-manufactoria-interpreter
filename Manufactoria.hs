module Manufactoria where

import System.SimpleArgs

import Tape
import Input
import Program
import Interpreter

main = do
    (argFile, argInput, argMode) <- getArgs

    progText <- readFile argFile

    let mode = read argMode
    let prog = parseProgram progText

    let result = readTape mode argInput >>= \input -> runProgram input prog

    case result of
        Nothing -> putStrLn $ "Invalid program or invalid input for the selected representation"
        (Just (MResult a t)) -> do
            putStr $ "Accepted: " ++ (show a)
            if a then putStrLn $ " | Final tape: " ++ maybe "Invalid tape to print in current representation" id (printTape mode t) else putStrLn ""
