STACK
Opcode	Stack	Description

#	(a--a a)	Duplicate TOS (DUP)
_	(a b--a)	Drop TOS (DROP)
$	(a b--b a)	Swap top 2 stack items (SWAP)
%	(a b--a b a)	Push 2nd (OVER)
@ access

~   not

/ div
// comment
/CHAR command or var
/K read key
' hex (temporary)

/h heap
/b byte mode
/d decimal mode (default true)

booleans 0, 'FFFF

? : ;       ternary
_ could be drop ... 

negate? not needed?
_	(a--b)	b: -a (Negate)


reserve \ for
\abc .... ;   lambda ????
