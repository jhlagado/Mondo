# Mondo Language

Mondo is a minimalist character-based interpreter but one which aims at fast performance, readability and ease of use. It is written for the Z80 microprocessor and is 2K.

## Table of Contents

- [Reverse Polish Notation (RPN)](#reverse-polish-notation-rpn)
- [Numbers in Mondo](#numbers-in-mondo)
  - [Decimal numbers](#decimal-numbers)
  - [Hexadecimal numbers](#hexadecimal-numbers)
  - [Formatting numbers](#formatting-numers)
- [Basic arithmetic operations](#basic-arithmetic-operations)
- [Variables and Variable Assignment](#variables-and-variable-assignment)
  - [Variable operators](#variable-operators)
- [Arrays](#arrays)
- [Data width](#data-width)
- [Strings](#strings)
- [String builder](#string-builder)
- [Logical operators](#logical-operators)
- [Code blocks](#code-blocks)
- [Conditional code](#conditional-code)
- [Functions in Mondo](#functions-in-mondo)
  - [Basic Function Syntax](#basic-function-syntax)
  - [Function with Multiple Arguments](#function-with-multiple-arguments)
  - [Calling functions](#calling-functions)
  - [Assigning Functions to Variables](#assigning-functions-to-variables)
  - [Using Functions](#using-functions)
- [SYSTEM VARIABLES](#system-variables)
- [Using Mondo on the TEC-1](#using-mondo-on-the-tec-1)
- [Loops](#loops)
- [LIST OF PRIMITIVES](#list-of-primitives)
- [Maths Operators](#maths-operators)
- [Logical Operators](#logical-operators)
- [Input & Output Operations](#input-output-operations)
- [User Defined Commands](#user-defined-commands)
- [Loops and conditional execution](#loops-and-conditional-execution)
- [Memory and Variable Operations](#memory-and-variable-operations)
- [System Variables](#system-variables)
- [Miscellaneous](#miscellaneous)
- [Utility commands](#utility-commands)

## Reverse Polish Notation (RPN)

RPN is a [concatenative](https://concatenative.org/wiki/view/Concatenative%20language)
way of writing expressions in which the operators come after their operands.
This makes it very easy to evaluate expressions, since the operands are already on the stack.

Here is an example of a simple Mondo program that uses RPN:

```
10 20 + .
```

This program pushes the numbers `10` and `20` are operands which are followed by an
operator `+` which adds the two operands together. The result becomes operand for
the `.` operator which prints the sum.

## Numbers in Mondo

Mondo on the Z80 uses 16-bit integers to represent numbers. A valid (but not very
interesting) Mondo program can be simply a sequence of numbers. Nothing will happen
to them though until the program encounters an operator.

There are two main types of numbers in Mondo: decimal numbers and hexadecimal numbers.

### Decimal numbers

Decimal numbers are represented in Mondo in the same way that they are represented
in most other programming languages. For example, the number `12345` is represented
as `12345`. A negative number is preceded by a `-` as in `-786`.

### Hexadecimal numbers

Hexadecimal numbers are represented in Mondo using the uppercase letters `A` to `F`
to represent the digits `10` to `15`. Hexadecimal numbers are prefixed with a `$`.
So for example, the hexadecimal number `1F3A` is represented as `$1F3A`.
Unlike decimal numbers, hexadecimal numbers are assumed to be positive in Mondo.

### Formatting numbers

Mondo provides commands for formatting hexadecimal and decimal numbers. The print
operator `.` prints numbers in the current base. To switch the base to hexadecimal
use the command `\\H` before using the `.` operator. To switch back to formatting
in decimal use the command `\\D`.

## Basic arithmetic operations

```
5 4 * .
```

In this program the numbers `5` and `4` are operands to the operator `*` which
multiplies them together. The `.` operator prints the result of the
multiplication.

```
10 20 - .
```

This program subtracts `20` from `10` which results in the negative value `-10`
The `.` operator prints the difference.

```
5 4 / .
```

This program divides 5 with 4 prints their quotient. Mondo for the Z80 uses
16-bit integers. The remainder of the last division operation can accessed using
the `\r` system variable.

```
\r .
```

## Variables and Variable Assignment

Variables are named locations in memory that can store data. Mondo has a limited
number of global variables which have single letter names. In Mondo a variable can
be referred to by a singer letter from `a` to `z` or from `A` to `Z` so there are 52
globals in Mondo. Global variables can be used to store numbers, strings, arrays, blocks, functions etc.

To assign the value `10` to the global variable `x` use the `!` operator.

```
10 x !
```

In this example, the number `3` is assigned to the variable `x`

To access a value in a variable `x`, simply refer to it.
This code adds `3` to the value stored in variable `x` and then prints it.

```
3 x + .
```

The following code assigns the hexadecimal number `$3FFF` to variable `A`
The second line fetches the value stored in `A` and prints it.

```
$3FFF A !
A .
```

In this longer example, the number `10` is stored in `a` and the number `20` is
stored in `b`. The values in these two variables are then added together and the answer
`30` is stored in `Z`. Finally `Z` is printed.

```
10 a !
20 b !
a b + Z !
Z .
```

## Variable operators

In Mondo, variables containing numeric values can be conveniently incremented and decremented

### Increment Operator ++

In Mondo, the increment operator ++ is used to increase the value of a variable by 1.

```
5 x !
x ++
```

In this example, the value of variable x is incremented by 1, making it 6.

### Decrement operator --

The decrement operator -- decreases the value of a variable by 1.

```
8 y !
y --
```

Here, the value of variable y is decremented by 1, reducing it to 7.

### Toggle operator ~

For variables that contain a boolean value, the toggle operator `~` can be used to switch between two states (0 or 1).

```
1 b !
b ~
```

In this example, the variable is assigned 1 (true) and is then toggled to 0 (false).

## Arrays

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

To access an element in an array, you can use the following syntax:

_array index "#"_

For example, the following code would access the second element in the array array:

```
a 1 # .
```

You can find the length of an array with the `\A` operator. For example, the following code would print the number of elements
in the array array:

```
a \A .
```

## Data width

Mondo can work in two modes: _byte mode_ and _word mode_. In byte mode, all values are assumed to be 8 bits, while in
word mode, all values are assumed to be 16 bits. The user can toggle between word mode and byte mode by using the command `\B`.
The mode is stored in the system variable `\b`. The default mode for Mondo is word mode. This means that if the user does not specify a mode, all values will be assumed to be 16 bits.

When Mondo is in word mode, the following rules apply:

- All values are stored as 16-bit integers.
- All operations are performed on 16-bit integers.

When Mondo is in byte mode, the following rules apply:

- All values are stored as 8-bit integers.
- All operations are performed on 8-bit integers.

This difference most relevant during memory access and working with arrays.

For example when an array is defined while in byte mode then all elements are assumed to be 8 bit and that indexes refer to
consecutive bytes.

```
\B [1 2 3] a !
```

Also array length is measured in bytes.

```
a \A .
```

This would print `3` bytes

If an array is defined while in word mode then all the elements are assumed to be 16 bits and that indexes refer to
consecutive 16 bit words.

## Strings

Mondo allows null-terminated strings to be defined by surrounding the string with `'` characters.

```
'hello there!' S !
```

Strings can be prints with the `\P` operator

```
S \P
```

prints out `hello there!`

A string can be treated like an array of bytes so in byte mode, we can select the third character by

```
S \B 3 # \C
```

`\C` prints the character "l"

### Printing values

Mondo has a number of ways of printing to the output.

`<value> .` prints a value as a number. This command is affected by \H /dc /byt /wrd  
`<value> \C` prints a value as an ASCII character
`<value> \P` prints a value as a pointer to a null terminated string

Additionally Mondo allows the user to easily print literal text by using \` quotes.

For example

```
100 x !
`The value of x is ` x .
```

prints `The value of x is 100`

## String builder

Anything that can be written to the screen can be captured and turned into a string
by using Mondo's string builder.

```
234 r !
123 g !
89  b !
\S `red: ` r . `green: ` g . `blue: ` b . \S T !
T \P
```

Stores `red: 234 green: 123 blue: 89` as a string in variable T.
It then prints the string in T

## Logical operators

Mondo uses numbers to define boolean values.

- false is represent by the number `0`
- true is any non-zero value, however the most useful representation is `1`.

```
3 0 = .
```

prints `0`

```
0 0 = .
```

prints `1`

Mondo has a set of bitwise logical operators that can be used to manipulate bits. These operators are:

`&` performs a bitwise AND operation on the two operands.
`|` performs a bitwise OR operation on the two operands.
`\x` performs a bitwise XOR operation on the two operands.
`{` shifts the bits of the operand to the left by the specified number of positions.
`}` shifts the bits of the operand to the right by the specified number of positions.

The bitwise logical operators can be used to perform a variety of operations on bits, such as:

- Checking if a bit is set or unset.
- Setting or clearing a bit.
- Flipping a bit.
- Counting the number of set bits in a number.

Here is an example of how to use the bitwise logical operators in Mondo:

Check if the first bit of the number 10 is set

```
10 & 1 .
```

this will print `1`

Set the fourth bit of the number 10

```
1 }}} 1 | \H .
```

prints $0009

Flip the third bit of the number 10

```
1 {{ $0F \X \H .
```

prints $000B

## Code blocks

You can put any code inside `:` and `;` block which tells Mondo to "execute this later".

Code blocks can be stored for later or immediately executed.

Storing a code block in the variable `Z`.

```
:Z `hello` 1. 2. 3. ;
```

Running the code block stored in `Z` by using the `^` (execute) operator

```
Z^
```

will print out.

```
hello 1 2 3
```

## Conditional code

Code blocks are useful when it comes to conditional code in Mondo.

The syntax for a Mondo IF-THEN-ELSE or "if...else" operator in Mondo is:

```
condition code-block-then code-block-else ?
```

If the condition is true, then code-block-then is evaluated and its value is returned.
Otherwise, code-block-else is evaluated and its value is returned.

Here is an example of a "if...else" operator in Mondo:

```
10 x !
20 y !

x y > ( 'x is greater than y' )( 'y is greater than x' ) z !

z \P
```

In this example, the variable x is assigned the value 10 and the variable y is assigned the value 20. The "if...else" operator then checks to see if x is greater than y. If it is, then the string "x is greater than y" is returned. Otherwise, the string "y is greater than x" is returned. The value of the "if...else" operator is then assigned to the variable z. Finally, the value of z is printed to the console.

Here is another example of the "if...else" operator in Mondo. This time, instead of creating a string just to print it, the following
code conditionally prints text straight to the console.

```
18 a !

`This person` a 18 > (`can`)(`cannot`) `vote`
```

In this example, the variable a is assigned the value 18. The "if...else" operator
then checks to see if age is greater than or equal to the voting age of 18. If it is,
then the text "can" is printed to the console. Otherwise, the string "cannot" is printed to the console.

Mondo can also select between multiple cases.

```
array key #
```

Here is an example that selects a number 0, 1, 2 or 3 and prints its text name.
The array of pairs is stored in `A`
Then we select `2` from the array and execute the corresponding block

```
[ :`zero`; :`one`; :`two`; :`three`; ] A !
A 2 #
```

## Functions in Mondo

In Mondo functions are anonymous and can be called directly or assigned to variables.
Functions are first-class citizens. They are a powerful feature of Mondo that can be used to
simplify code and make it more concise.

### Basic Function Syntax

In Mondo, functions are denoted by the `\` symbol followed by one or more arguments
(single lowercase letters) and a `:` symbol to indicate the beginning of the
function expression. The body of the function is written using Reverse Polish Notation (RPN),
where `%` is used to reference the function's arguments.

A basic function with a single argument is represented as follows:

```
:F a ! a . ;
```

This function takes a single argument `a` and prints its value using the `.` operator.

Example: a function to square a value a

```
:F a ! a a * ;
```

### Function with Multiple Arguments

You can also define functions with multiple arguments. For example:

```
:F b ! a ! a b + . ;
```

This function takes two arguments `a` and `b`, adds them together using the `+` operator,
and then prints the result using `.`.

### Calling functions

Functions are called with the ^ operator

```
:F b ! a ! a b * ;
30 20 F ^ .
```

This code passes the numbers `30` and `20` to a function which multiplies them and returns
the result which is then printed.

### Assigning Functions to Variables

In Mondo, you can assign functions to variables just like any other value.
Variables in Mondo are limited to a single uppercase or lowercase letter. To
assign a function to a variable, use the `=` operator.

Let's see some examples:

Here's a function to print a number between after a `$` symbol and storing t in variable `A`

```
:A a ! `$` a . ;
```

And calling it:

```
100 A^
```

The `100` is passed to the function as argument `a`. The function first prints `$` followed by `1001

Here's a function to square two numbers. The function is stored in variable S

```
:S a ! a a * ;
```

Calling it:

```
4 S ^ .
```

The number `4` is passed to the function S which squares the value and then prints it.

```
:T b ! a ! a b + ;
```

### Using Functions

Once you've assigned functions to variables, you can use them in your Mondo code.
To execute a function and pass arguments to it, use the `^` operator. The function's
body will be executed, and the result, if any, will be printed.

Example:

```
10 A^       // prints 10
3 7 B^      // prints 10, the sum of 3 and 7
```

In the first line, we execute the function stored in variable `A` with the argument `10`,
which prints `10`. In the second line, we execute the function stored in variable `B` with
arguments `3` and `7`, which results in `10` being printed (the sum of the two arguments).

### SYSTEM VARIABLES

System variables contain values which Mondo uses internally but are available for programmatic use. These are the lowercase letters preceded by a \ e.g. \a, \b, \c etc. However Mondo only uses a few of these variables so the user may use the other ones as they like.

### Using Mondo on the TEC-1

Mondo was designed for for small Z80 based systems but specifically with the small memory configuration of the TEC-1 single board computer. It is only 2K to work with the original TEC-1 and interfaces to the serial interface via a simple adapter.

On initialisation it will present a user prompt ">" followed by a CR and LF. It is now ready to accept commands from the keyboard.

### Loops

0(this code will not be executed but skipped)
1(this code will be execute once)
10(this code will execute 10 times)

You can use the comparison operators < = and > to compare 2 values and conditionally execute the code between the brackets.

### List of operators

Mondo is a bytecode interpreter - this means that all of its instructions are 1 byte long. However, the choice of instruction uses printable ASCII characters, as a human readable alternative to assembly language. The interpreter handles 16-bit integers and addresses which is sufficient for small applications running on an 8-bit cpu.

### Maths Operators

| Symbol | Description                               | Effect   |
| ------ | ----------------------------------------- | -------- |
| -      | 16-bit integer subtraction SUB            | a b -- c |
| /      | 16-bit by 8-bit division DIV              | a b -- c |
| +      | 16-bit integer addition ADD               | a b -- c |
| \*     | 8-bit by 8-bit integer multiplication MUL | a b -- c |
| \>     | 16-bit comparison GT                      | a b -- c |
| <      | 16-bit comparison LT                      | a b -- c |
| =      | 16 bit comparison EQ                      | a b -- c |
| {      | shift left                                | --       |
| }      | shift right                               | --       |

### Logical Operators

| Symbol | Description        | Effect   |
| ------ | ------------------ | -------- |
| \|     | 16-bit bitwise OR  | a b -- c |
| &      | 16-bit bitwise AND | a b -- c |
| \\X    | xor                | a b -- c |

Note: logical NOT can be achieved with 0=

### Variable operators

| Symbol | Description | Effect |
| ------ | ----------- | ------ |
| ++     | increment   | a -- b |
| --     | decrement   | a -- b |
| ~      | toggle      | a -- b |

### Input & Output Operations

| Symbol | Description                                               | Effect |
| ------ | --------------------------------------------------------- | ------ |
| $      | the following number is in hexadecimal                    | a --   |
| .      | print the top member of the stack as a decimal number DOT | a --   |
| \`     | print the literal string between \` and \`                | --     |
| \\K    | key input                                                 | --     |
| \\P    | print string                                              | --     |
| \\N    | print new line                                            | --     |
| \\I    | in port                                                   | --     |
| \\O    | out port                                                  | --     |

### User Defined Commands

| Symbol  | Description                   | Effect   |
| ------- | ----------------------------- | -------- |
| :<CHAR> | define a new command DEF      |          |
| ;       | end of user definition END    |          |
| ^       | execute Mondo code at address | adr -- ? |
| \\Q     | condtional early return       | b --     |

NOTE:
<CHAR> is an uppercase or lowercase letter immediately following operation which is the name of the definition

### Loops and conditional execution

| Symbol | Description                            | Effect |
| ------ | -------------------------------------- | ------ |
| (      | BEGIN a loop which will repeat n times | n --   |
| )      | END a loop code block                  | --     |
| \\W    | if false break out of loop             | b --   |

NOTE 1: a loop with a boolean value for a loop limit (i.e. 0 or 1) is a conditionally executed block of code

e.g. 0(`will not execute`)
1(`will execute`)

NOTE 2: if you _immediately_ follow a code block with another code block, this second code block will execute
if the condition is 0 (i.e. it is an ELSE clause)

e.g. 0(`will not execute`)(`will execute`)
1(`will execute`)(`will not execute`)

### Memory and Variable Operations

| Symbol | Description               | Effect           |
| ------ | ------------------------- | ---------------- |
| !      | store a value to memory   | val --           |
| [      | begin an array definition | --               |
| ]      | end an array definition   | -- adr           |
| #      | access array              | adr num -- value |
| '      | string definition         | -- adr           |
| \\A    | array size                | --               |
| \\B    | toggle byte mode          | --               |

### System Variables

| Symbol | Description    |
| ------ | -------------- |
| \\a    | buffer pointer |
| \\b    | byte mode      |
| \\c    | carry          |
| \\e    | echo mode      |
| \\h    | heap pointer   |
| \\i    | virtual var i  |
| \\j    | virtual var j  |
| \\p    | pointer        |
| \\r    | remainder      |
| \\s    | string mode    |
| \\t    | TIB pointer    |
| \\x    | hex mode       |

### Miscellaneous

| Symbol | Description                                   | Effect |
| ------ | --------------------------------------------- | ------ |
| \\\\   | comment text, skips reading until end of line | --     |
| \\G    | go                                            | --     |
| \\D    | decimal                                       | --     |
| \\H    | hexadecimal                                   | --     |
| \\C    | print char                                    | --     |
