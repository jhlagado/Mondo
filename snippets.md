cstore* ;a1 \! byte store  
anonDef* ;ba \: return add of a anon def, \: 1 2 3; \\ ret add of this  
cFetch* ;c0 \@ byte fetch
cArrDef* ;db \[
comment\_ ;dc \\ comment text, skips reading until end of line

break* ; \B \~ ( b -- ) conditional break from loop  
depth* ; \D \- num items on stack
emit* ;ac \E \, ( b -- ) prints a char  
go* ;de \G \^ execute Mondo definition a is address of Mondo code
inPort* ;bc \I \< ( port -- val )
editDef* ;a3 \L \# edit definition
newln* ;a4 \N \$ prints a newline to output
outPort* ;be \O \> ( val port -- )
prompt* ;bf \P \? print Mondo prompt
printStk* ; \S \_ non-destructively prints stack  
break* ; \W \~ ( b -- ) conditional break from loop  
exec* ;bb \X \; execute machine code
