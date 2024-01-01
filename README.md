# Mondo Language 1.3

Mondo is a minimalist character-based interpreter but one which aims at fast performance, readability and ease of use. It is written for the Z80 microprocessor and is 2K.

- [What is Mondo?](#what-is-Mondo)
- [Reverse Polish Notation (RPN)](<#reverse-polish-notation-(rpn)>)
- [Numbers](#numbers)
  - [Decimal numbers](#decimal-numbers)
  - [Hexadecimal numbers](#hexadecimal-numbers)
  - [Formatting numbers](#formatting-numbers)
- [Printing](#printing)
  - [Printing numbers](#printing-numbers)
  - [Printing text](#printing-text)
- [Stack Manipulation](#stack-maniplation)
  - [Duplicate](#duplicate)
  - [Drop](#drop)
  - [Swap](#swap)
  - [Over](#over)
  - [Rotate](#rotate)
- [Variables](#variables)
- [System variables](#system-variables)
- [Basic arithmetic operations](#basic-arithmetic-operations)
- [Logical operators](#logical-operators)
- [Arrays](#arrays)
  - [Basic arrays](#basic-arrays)
  - [Array size](#array-size)
  - [Nested arrays](#nested-arrays)
  - [Byte arrays](#byte-arrays)
- [Loops](#loops)
- [Conditional code](#conditional-code)
- [Functions](#functions)
  - [Function with multiple arguments](#function-with-multiple-arguments)
  - [Calling functions](#calling-functions)
  - [Using functions](#using-functions)
  - [Anonymous functions](#anonymous-functions)
- [Appendices](#appendices)
  - [Using Mondo on the TEC-1](#using-Mondo-on-the-tec-1)
  - [List of operators](#list-of-operators)
  - [Maths Operators](#maths-operators)
  - [Logical Operators](#logical-operators-1)
  - [Stack Operations](#stack-operations)
  - [Input & Output Operations](#input-&-output-operations)
  - [Loops and conditional execution](#loops-and-conditional-execution)
  - [Memory and Variable Operations](#memory-and-variable-operations)
  - [Array Operations](#array-operations)
  - [System Variables](#system-variables-1)
  - [Miscellaneous](#miscellaneous)
  - [Utility commands](#utility-commands)
  - [Control keys](#control-keys)

## <a name='what-is-Mondo'></a>What is Mondo?

Mondo is a bytecode interpreter - this means that all of its instructions are 1 byte long. However,
the choice of instruction uses printable ASCII characters, as a human readable alternative to assembly
language. The interpreter handles 16-bit integers and addresses which is sufficient for small applications
running on an 8-bit cpu.

## <a name='reverse-polish-notation-(rpn)'></a>Reverse Polish Notation (RPN)

RPN is a [concatenative](https://concatenative.org/wiki/view/Concatenative%20language)
way of writing expressions in which the operators come after their operands. Concatenative
languages make use of a stack which is uses to collect data to do work on. The results
are pushed back on the stack.

Here is an example of a simple Mondo program that uses RPN:

```
10 20 + .
```

As the interpreter encounters numbers it pushes them on to the stack. Then it encounters the
`+` operator which is uses to add the two items on the stack and pushes the result back on the stack.
The result becomes the data for the `.` operator which prints the number to the console.

## <a name='numbers'></a>Numbers

Mondo on the Z80 uses 16-bit integers to represent numbers. A valid (but not very
interesting) Mondo program can be simply a sequence of numbers. Nothing will happen
to them though until the program encounters an operator.

There are two main types of numbers in Mondo: decimal numbers and hexadecimal numbers.

### <a name='decimal-numbers'></a>Decimal numbers

Decimal numbers are represented in Mondo in the same way that they are represented
in most other programming languages. For example, the number `12345` is represented
as `12345`. A negative number is preceded by a `-` as in `-786`.

### <a name='hexadecimal-numbers'></a>Hexadecimal numbers

Hexadecimal numbers are represented in Mondo using the uppercase letters `A` to `F`
to represent the digits `10` to `15`. Hexadecimal numbers are prefixed with a `'` character. So for example, the hexadecimal number `1F3A` is represented as `'1F3A`.
Unlike decimal numbers, hexadecimal numbers are assumed to be positive in Mondo.

## <a name='printing'></a>Printing

### <a name='printing-numbers'></a>Printing numbers

Mondo provides commands for printing numbers in decimal and hexadecimal format.

The `.` operator prints numbers to the console in decimal.
The `,` operator prints numbers to the console in hexadecimal.

### <a name='printing-text'></a>Printing text

Mondo allows the user to easily print literal text by using \` quotes.

For example

```
100 x !
`The value of x is ` x .
```

prints `The value of x is 100`

## <a name='stack-maniplation'></a>Stack Manipulation

In Mondo, the stack is a central data structure that stores values temporarily.
Let's explore some fundamental operators that help you manage the stack

### <a name='duplicate'></a>Duplicate

The `#` or "dup" operator _duplicates_ the top element of the stack.

The following code prints `10 10`

```
10 # . .
```

### <a name='drop'></a>Drop

The `\` or "drop" removes the top element of the stack.

The following code prints `20`

```
20 30 \ .
```

### <a name='swap'></a>Swap

The `$` of "swap" operator exchanges the positions of the top two elements on the stack.

The following code prints `50 40`

```
40 50 $ . .
```

### <a name='over'></a>Over

The `%` of "over" operator copies the second element from the top of the stack and
places it on top.

The following code prints `60 70 60`

```
60 70 % . . .
```

## <a name='variables'></a>Variables

Variables are named locations in memory that can store data. Mondo has a limited
number of global variables which have single letter names. In Mondo a variable can
be referred to by a singer letter from `a` to `z` so there are 26
global variables in Mondo. Global variables can be used to store numbers, strings, arrays, blocks, functions etc.

To assign the value `10` to the global variable `x` use the `!` operator.

```
10 x !
```

In this example, the number `10` is assigned to the variable `x`

The code below adds `3` to the value stored in variable `x` and then prints it.

```
3 x + .
```

The following code assigns the hexadecimal number `'3FFF` to variable `a`
The second line fetches the value stored in `a` and prints it.

```
'3FFF a !
a .
```

In this longer example, the number 10 is stored in `a` and the number `20` is
stored in `b`. The values in these two variables are then added together and the answer
`30` is stored in `z`. Finally `z` is printed.

```
10 a !
20 b !
a b + z !
z .
```

## <a name='system-variables'></a>System variables

In addition to the 26 general purpose variables, Mondo has a 26 system variables which have special uses. System variables start with a `/` followed by a lowercase character.

## <a name='basic-arithmetic-operations'></a>Basic arithmetic operations

In this program the numbers `5` and `4` are operands to the operator `*` which
multiplies them together. The `.` operator prints the result of the
multiplication.

```
5 4 * .
```

This program subtracts `20` from `10` which results in the negative value `-10`
The `.` operator prints the difference.

```
10 20 - .
```

This program divides 5 with 4 prints the result.

```
5 4 / . .
```

The remainder of the last division operation is available in the `/r` system variable.

```
/r .
```

## <a name='logical-operators'></a>Logical operators

Mondo uses numbers to define boolean values.

- false is represented by the number `0`
- true is represented by the number `-1`of `'FFFF`.

For clarity Mondo allows boolean values to be expressed as `/t` and `/f`
(that's true and false respectively)

```
3 0 = .
```

prints `0`

```
0 0 = .
```

prints `1`

Mondo has a set of bitwise logical operators that can be used to manipulate bits. These operators are:

```
& performs a bitwise AND operation on the two operands.
| performs a bitwise OR operation on the two operands.
^ performs a bitwise XOR operation on the two operands.
~ performs a bitwise NOT on one operand.
/L shifts the bits of the operand to the left by one.
/R shifts the bits of the operand to the right by one.
```

The bitwise logical operators can be used to perform a variety of operations on bits, such as:

- Checking if a bit is set or unset.
- Setting or clearing a bit.
- Flipping a bit.
- Counting the number of set bits in a number.

Here is an example of how to use the bitwise logical operators in Mondo:

Check if the first bit of the number 10 is set

```
11 1 & ,
```

this will print 0001

Shift 1 three times to the left (i.e. multiple by 8) and then OR 1 with the least significant bit.

```
1 3 /L 1 | ,
```

prints 0009

Shift 1 two times to the left (i.e. multiple by 4) and then XOR '000F and then mask with '000F.

```
1 2 /L 'F ^ 'F & ,
```

The following inverts 'FFFF and prints 0

```
'FFFF ~ .
```

prints 000B

## <a name='arrays'></a>Arrays

### <a name='basic-arrays'></a>Basic arrays

Mondo arrays are a type of data structure that can be used to store a collection of elements. Arrays are indexed, which means that each element in the array has a unique number associated with it. This number is called the index of the element.
In Mondo, array indexes start at 0

To create a Mondo array, you can use the following syntax:

_[ element1 element2 ... ]_

for example

```
[ 1 2 3 ]
```

Arrays can be assigned to variables just like number values

```
[ 1 2 3 ] a !
```

An array of 16-bit numbers can be defined by enclosing them within square brackets:

```
[ 1 2 3 4 5 6 7 8 9 0 ]
```

Defining an array puts its start address onto the stack

These can then be allocated to a variable, which acts as a pointer to the array in memory

```
[ 1 2 3 4 5 6 7 8 9 0 ] a !
```

To fetch the Nth member of the array, we can create use the index operator `@`

The following prints the item at index 2 (which is 3).

```
[ 1 2 3 ] 2@  .
```

### <a name='array-size'></a>Array size

The size of an array can be determined with the `/S` operator which puts the number
of items in the array on the stack.

The following prints 5 on the console.

```
[ 1 2 3 4 5 ] /S .
```

### <a name='nested-arrays'></a>Nested arrays

In Mondo arrays can be nested inside one another.

The following code shows an array with another array as its second item.
This code accesses the second item of the first array with `1@ `. It then accesses
the first item of the inner array with `0@ ` and prints the result (which is 2).

```
[1 [2 3]] 1@  0@  .
```

## <a name='loops'></a>Loops

Looping in Mondo is of the form

```
number (code to execute)
```

The number represents the number of times the code between parentheses will be repeated. If the number is zero then the code will be skipped. If the number
is ten it will be repeated ten times. If the number is -1 then the loop will repeat forever.

```
0(this code will not be executed but skipped)
1(this code will be execute once)
10(this code will execute 10 times)
/f(this code will not be executed but skipped)
/t(this code will be execute once)
/u(this code will be execute forever)
```

This code following prints ten x's.

```
10 (`x`)
```

The following code repeats ten times and adds 1 to the variable `t` each time.
When the loop ends it prints the value of t which is 10.

```
0t! 10( t 1+ t! ) t .
```

Mondo provides a special variable `/i` which acts as a loop counter. The counter counts up from zero. Just before the
counter reaches the limit number it terminates.

This prints the numbers 0 to 9.

```
10 ( /i . )
```

Loops can repeat forever by specifying an "unlimited" loop with /u. These can be controlled with the "while" operator `/W`. Passing a false value to /W will terminate the loop.

This code initialises `t` to zero and starts a loop to repeat 10 times.
The code to repeat accesses the `/i` variable and compares it to 4. When `/i` exceeds 4 it breaks the loop.
Otherwise it accesses `t` and adds 1 to it.

Finally when the loop ends it prints the value of t which is 5.

```
0t! /u(/i 4 < /W /i t 1+ t!) t .
```

Loops can be nested and then special `/j` variable is provided to access the counter of the outer loop.

The following has two nested loops with limits of 2. The two counter variables are summed and added to `t`.
When the loop ends `t` prints 4.

```
0t! 2(2(/i /j + t + t! )) t .
```

## <a name='conditional-code'></a>Conditional code

Mondo's looping mechanism can also be used to execute code conditionally. In Mondo boolean `false` is represented
by 0 and `true` is represented by 1.

```
/f(this code will not be executed but skipped)
/t(this code will be execute once)
```

The following tests if `x` is less that 5.

```
3 x!
x 5 < (`true`)
```

The syntax for a Mondo IF-THEN-ELSE or "if...else" operator in Mondo is and
extension of the loop syntax.

```
boolean (code-block-then) /e (code-block-else)
```

If the condition is true, then code-block-then is executed. Otherwise, code-block-else is executed.

Here is an example of a "if...else" operator in Mondo:

```
10 x !
20 y !

x y > ( `x is greater than y` ) /e ( `y is greater than x` )

```

In this example, the variable x is assigned the value 10 and the variable y is assigned the value 20.
The "if...else" operator then checks to see if x is greater than y. If it is, then the string
"x is greater than y" is returned. Otherwise, the string "y is greater than x" is returned.

Here is another example of the "if...else" operator in Mondo. This time, instead of creating a string just to print it, the following
code conditionally prints text straight to the console.

```
18 a !

`This person` a 17 > (`can`) /e (`cannot`) `vote`
```

In this example, the variable a is assigned the value 18. The "if...else" operator
then checks to see if age is greater than 17. If it is,
then the text "can" is printed to the console. Otherwise, the string "cannot" is printed.

## <a name='functions'></a>Functions

You can put any code inside `:` and `;` block which tells Mondo to "execute this later".

Functions are stored in variables with uppercase letters. There are 26 variables
for storing functions in Mondo and use the uppercase letter A to Z.

The following stores a function in the variable `Z`.

```
:Z `hello` 1. 2. 3. ;
```

Running the function by stored in uppercase `Z` by referring to it

```
Z
```

will print out.

```
hello 1 2 3
```

A basic function to square a value.

```
:F " * ;
```

The function stored in F duplicates the value on the stack and then multiplies them together.

```
4 F .
```

Calling the function with 4 returns 16 which is then printed.

### <a name='function-with-multiple-arguments'></a>Function with multiple arguments

You can also define functions with multiple arguments. For example:

```
:F $ . . ;
```

This function swaps the top two arguments on the stack and then prints them using `.`.

### <a name='calling-functions'></a>Calling functions

Functions are called by referring to them

```
:F * ;
30 20 F .
```

This code passes the numbers `30` and `20` to a function which multiplies them and returns
the result which is then printed.

### <a name='using-functions'></a>Using functions

Once you've assigned functions to variables, you can use them in your Mondo code.

Example:

```
10 A       // prints 10
3 7 B      // prints 10, the sum of 3 and 7
```

In the first line, we execute the function stored in variable `A` with the argument `10`,
which prints `10`. In the second line, we execute the function stored in variable `B` with
arguments `3` and `7`, which results in `10` being printed (the sum of the two arguments).

### <a name='anonymous-functions'></a>Anonymous functions

Mondo code is not restricted to upper case variables. Functions an be declared without a
variable(i.e. anonymously) by using the `::` operator. A function declared this way puts
the address of the function on the stack.

A function at an address can be executed with the `/G` operator.

This code declares an anonymous function and stores its address in `a`. This function will
increment its argument by 1.

The next line pushs the number 3 on the stack and executes the function in `a`.
The function adds 1 and prints 4 to the console.

```
:: 1+ ; a!
3 a /G .
```

Anonymous functions can be stored in arrays and can even be used as a kind of "switch" statement.
This code declares an array containing 3 anonymous functions. The next line accesses the array at
index 2 and runs it. "two" is printed to the console.

```
[:: `zero` ; :: `one` ; :: `two` ;] b!
b 2@ /G
```

## <a name='appendices'></a>Appendices

### <a name='using-Mondo-on-the-tec-1'></a>Using Mondo on the TEC-1

Mondo was designed for for small Z80 based systems but specifically with the small memory configuration
of the TEC-1 single board computer. It is only 2K to work with the original TEC-1 and interfaces to the
serial interface via a simple adapter.

On initialisation it will present a user prompt ">" followed by a CR and LF. It is now ready to accept
commands from the keyboard.

### <a name='list-of-operators'></a>List of operators

### <a name='maths-operators'></a>Maths Operators

| Symbol | Description                               | Effect   |
| ------ | ----------------------------------------- | -------- |
| -      | 16-bit integer subtraction SUB            | a b -- c |
| /      | 16-bit by 8-bit division DIV              | a b -- c |
| +      | 16-bit integer addition ADD               | a b -- c |
| \*     | 8-bit by 8-bit integer multiplication MUL | a b -- c |

### <a name='logical-operators-1'></a>Logical Operators

| Symbol | Description          | Effect   |
| ------ | -------------------- | -------- |
| \>     | 16-bit comparison GT | a b -- c |
| <      | 16-bit comparison LT | a b -- c |
| =      | 16 bit comparison EQ | a b -- c |
| &      | 16-bit bitwise AND   | a b -- c |
| \|     | 16-bit bitwise OR    | a b -- c |
| ^      | 16-bit bitwise XOR   | a b -- c |
| ~      | 16-bit bitwise NOT   | a -- c   |
| /L     | shift left           | n n --   |
| /R     | shift right          | n n --   |

### <a name='stack-operations'></a>Stack Operations

| Symbol | Description                                                          | Effect       |
| ------ | -------------------------------------------------------------------- | ------------ |
| \\     | drop the top member of the stack DROP                                | a a -- a     |
| #      | duplicate the top member of the stack DUP                            | a -- a a     |
| $      | swap the top 2 members of the stack SWAP                             | a b -- b a   |
| %      | over - take the 2nd member of the stack and copy to top of the stack | a b -- a b a |
| /D     | stack depth                                                          | -- n         |

### <a name='input-&-output-operations'></a>Input & Output Operations

| Symbol | Description                                    | Effect |
| ------ | ---------------------------------------------- | ------ |
| ?      | read a char from input                         | -- c   |
| .      | print the number on the stack as a decimal     | a --   |
| ,      | print the number on the stack as a hexadecimal | a --   |
| \`     | print the literal string between \` and \`     | --     |
| /E     | prints a character to output                   | n --   |
| /O     | output to an I/O port                          | n p -- |
| /I     | input from a I/O port                          | p -- n |
| '      | the following number is in hexadecimal         | a --   |

| Symbol  | Description                     | Effect   |
| ------- | ------------------------------- | -------- |
| ;       | end of user definition END      |          |
| :<CHAR> | define a new command DEF        |          |
| /:      | define an anonymous command DEF | -- adr   |
| /G      | execute Mondo code at address   | adr -- ? |
| /X      | execute machine code at address | adr -- ? |

NOTE:
<CHAR> is an uppercase letter immediately following operation which is the name of the definition

### <a name='loops-and-conditional-execution'></a>Loops and conditional execution

| Symbol | Description                            | Effect |
| ------ | -------------------------------------- | ------ |
| (      | BEGIN a loop which will repeat n times | n --   |
| )      | END a loop code block                  | --     |
| /W     | if false break out of loop             | b --   |
| /e     | else condition                         | -- b   |
| /i     | loop counter variable                  | -- n   |
| /j     | outer loop counter variable            | -- n   |

NOTE 1: a loop with a boolean value for a loop limit (i.e. 0 or 1) is a conditionally executed block of code

```
0(`will not execute`)
1(`will execute`)
```

NOTE 2: if you follow a code block with `/e` followed by another code block, this second code block will execute the "else" condition.

```
0(`will not execute`) /e (`will execute`)
1(`will execute`) /e (`will not execute`)
```

### <a name='memory-and-variable-operations'></a>Memory and Variable Operations

| Symbol | Description             | Effect   |
| ------ | ----------------------- | -------- |
| !      | STORE a value to memory | n adr -- |
| /B     | toggle byte mode        | --       |

### <a name='array-operations'></a>Array Operations

| Symbol | Description               | Effect         |
| ------ | ------------------------- | -------------- |
| [      | begin an array definition | --             |
| ]      | end an array definition   | -- adr         |
| @      | get address of array item | adr idx -- adr |
| /S     | array size                | adr -- n       |

### <a name='system-variables-1'></a>System Variables

| Symbol | Description               | Effect  |
| ------ | ------------------------- | ------- |
| /c     | carry flag variable       | -- b    |
| /e     | else condition            | -- b    |
| /f     | false                     | -- b    |
| /h     | heap pointer              | -- adr  |
| /i     | loop counter              | -- n    |
| /j     | outer loop counter        | -- n    |
| /k     | text input buffer pointer | -- adr  |
| /p     | last access pointer       | -- adr  |
| /r     | last division remainder   | -- adr  |
| /s     | data stack start          | -- adr  |
| /t     | true                      | -- b    |
| /u     | unlimited loop            | -- n    |
| /z     | last definition           | -- char |

### <a name='miscellaneous'></a>Miscellaneous

| Symbol | Description                                   | Effect |
| ------ | --------------------------------------------- | ------ |
| //     | comment text, skips reading until end of line | --     |

### <a name='utility-commands'></a>Utility commands

| Symbol | Description   | Effect  |
| ------ | ------------- | ------- |
| /UN    | prints a CRLF | --      |
| /UE    | edit command  | char -- |
| /UP    | print prompt  | --      |
| /US    | print stack   | --      |

### <a name='control-keys'></a>Control keys

| Symbol | Description       |
| ------ | ----------------- |
| ^E     | edit a definition |
| ^H     | backspace         |
| ^J     | re-edit           |
| ^L     | list definitions  |
| ^P     | print stack       |
