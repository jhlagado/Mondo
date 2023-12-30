STACK
Opcode	Stack	Description

" -> #	(a--a a)	Duplicate TOS (DUP)
' -> _	(a b--a)	Drop TOS (DROP)
$	(a b--b a)	Swap top 2 stack items (SWAP)
%	(a b--a b a)	Push 2nd (OVER)

_ -> @ access

!!!!! ~   not

\ -> /
/ div
\\ -> // comment
\CHAR -> /CHAR command or var
? -> /K read key

# -> ' hex literal (temporary)

\d -> /b byte mode

booleans 0, 'FFFF


( /W ) loops

reserve \ for
\abc .... ;   lambda ????


conditionals
? : ;       ternary

/B
/W !!!! used for while
/H
/D


