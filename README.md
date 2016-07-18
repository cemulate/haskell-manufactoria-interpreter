## Haskell Manufactoria Interpreter

An implementation of the [Manufactoria Esolang](https://esolangs.org/wiki/Manufactoria).
Usage is:

    runhaskell Manufactoria.hs programFile input [Color|Binary|Decimal]

Where the third argument selects how the input will be read and printed back out in the end

* `Color` expects input in the form of color sequences consisting of (upper case or lower case) characters from `RBGY`
* `Binary` expects input in the form of binary strings (using the convention `Red=0, Blue=1`)
* `Decimal` expects input in the form of a decimal number, which will be converted to binary by the same convention

`programFile` should be a text file containing a program in the [Manufactoria Esolang](https://esolangs.org/wiki/Manufactoria) syntax.

#### Example

The program in `test1.txt` will accept and output a tape consisting of the last character in the input tape:

    \> runhaskell Manufactoria.hs test/test1.txt RRBBBGGYYGY Color
    Accepted: True | Final tape: Y
