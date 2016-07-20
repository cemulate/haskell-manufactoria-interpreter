## Haskell Manufactoria Interpreter

An implementation of the [Manufactoria Esolang](https://esolangs.org/wiki/Manufactoria) with extensions/changes as defined below.
Usage is:

    runhaskell Manufactoria.hs programFile [Color|Binary|Decimal] input

Where the second argument selects how the input will be read and printed back out in the end

* `Color` expects input in the form of color sequences consisting of (upper case or lower case) characters from `RBGY`
* `Binary` expects input in the form of binary strings (using the convention `Red=0, Blue=1`)
* `Decimal` expects input in the form of a decimal number, which will be converted to binary by the same convention

`programFile` should be a text file containing a program in the esolang syntax.

**Note**: This implementation makes a small change to the syntax described in the [Manufactoria Esolang](https://esolangs.org/wiki/Manufactoria).
Any of the start and end characters there are still accepted, but their meanings are ignored, as input and output representation is specified by the command line argument.

#### Example

The program in `test1.txt` will output a tape consisting of the last character in the input tape:

    > runhaskell Manufactoria.hs test/test1.txt Color RRBBBGGYYGY
    Accepted: True | Final tape: Y

## Changes to Specifications

This interpreter makes a few changes to the [Manufactoria Esolang](https://esolangs.org/wiki/Manufactoria) spec:

* The robot moves **down** from the start tile at the beginning, as this is the behavior in the original game. The original esolong specifies that the robot moves right from the start.
* `@`, `0`, and `&` are all accepted as start characters, but their meaning is discarded, since the format of the input and output is specified by an argument on the command line.
* `!`, `$`, `;`, and `.` are all accepted as end characters, but their meaning is also discarded. The program always prints the acceptance and the final tape in the format specified.
* The original spec uses `#` to represent a bridge, a tile that keeps the "robot" moving in the same direction. However, this cannot represent all valid Manufactoria programs. It is possible in the original game to move onto a crossed conveyor tile and move backward to where you came from (that is, the *axis* of your movement is determined by the direction you enter, but not the destination). As a result, `#` still works with its intended meaning, but we also introduce four new explicit characters to capture all possible conveyor crossing possibilities:
  * `]`: Right conveyor and down conveyor crossed
  * `}`: Right conveyor and up conveyor crossed
  * `[`: Left conveyor and down conveyor crossed
  * `{`: Left conveyor and up conveyor crossed
 
I'm referring to this extension as the "Extended Manufactoria Esolang", and you can it is available as an export option from my [Manufactoria editor](https://cemulate.github.io/manufactoria-editor/). When exporting a program, you *must* use the extended esolang if your program contains crossed conveyors of the particular behavior discussed above. If it does not, the regular esolang export is fine.
