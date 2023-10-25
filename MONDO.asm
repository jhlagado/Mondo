; *************************************************************************
;
;       Mondo Minimal Interpreter for the Z80 
;
;       by John Hardy and contains code from the 
;       MINT project by Ken Boak and Craig Jones. 
;
;       GNU GENERAL PUBLIC LICENSE                   Version 3, 29 June 2007
;
;       see the LICENSE file in this repo for more information 
;
; *****************************************************************************

    TRUE        equ 1		
    FALSE       equ 0
    NULL        equ 0  
    ETX         equ 3

.macro LITDAT,len
    db len
.endm

.macro REPDAT,len,data			; compress the command tables
    
    db (len | $80)
    db data
.endm

.macro ENDDAT
    db 0
.endm

; **************************************************************************
; Page 0  Initialisation
; **************************************************************************		

	.ORG ROMSTART + $180		; 0+180 put Mondo code from here	

iOpcodes:
    LITDAT 15
    db lsb(bang_)           ;   !            
    db lsb(nop_)            ;   "
    db lsb(hash_)           ;   #
    db lsb(dollar_)         ;   $            
    db lsb(nop_)            ;   %            
    db lsb(amper_)          ;   &
    db lsb(quote_)          ;   '
    db lsb(lparen_)         ;   (        
    db lsb(rparen_)         ;   )
    db lsb(star_)           ;   *            
    db lsb(plus_)           ;   +
    db lsb(nop_)            ;   ,            
    db lsb(minus_)          ;   -
    db lsb(dot_)            ;   .
    db lsb(slash_)          ;   /	

    REPDAT 10, lsb(num_)		; 10 x repeat lsb of add to the num routine 

    LITDAT 7
    db lsb(colon_)          ;   :        
    db lsb(semi_)           ;   ;
    db lsb(lt_)             ;   <
    db lsb(eq_)             ;   =            
    db lsb(gt_)             ;   >            
    db lsb(nop_)            ;   ?   ( -- val )  read a char from input
    db lsb(at_)             ;   @    

    REPDAT 26, lsb(var_)	; call a command A, B ....Z

    LITDAT 6
    db lsb(lbrack_)         ;    [
    db lsb(backslash_)      ;    \
    db lsb(rbrack_)         ;    ]
    db lsb(caret_)          ;    ^   ; execute Mondo code
    db lsb(nop_)            ;    _
    db lsb(grave_)          ;    `   ; print literal `hello`        

    REPDAT 26, lsb(var_)		; a b c ...z

    LITDAT 4
    db lsb(shl_)            ;    {
    db lsb(pipe_)           ;    |            
    db lsb(shr_)            ;    }            
    db lsb(tilde_)          ;    ~             

iAltCodes:

    LITDAT 26
    db lsb(arrayLength_)    ;       \A  ; array size          
    db lsb(togByteMode_)    ;       \B  ; toggle byte mode         
    db lsb(prnChar_)        ;       \C  ; print char          
    db lsb(decimal_)        ;       \D  ; decimal          
    db lsb(aNop_)           ;       \E  ;           
    db lsb(aNop_)           ;       \F  ;           
    db lsb(go_)             ;       \G  ; go           
    db lsb(hexadecimal_)    ;       \H  ; hexadecimal          
    db lsb(inPort_)         ;       \I  ; in port           
    db lsb(aNop_)           ;       \J  ;      
    db lsb(key_)            ;       \K  ; key input           
    db lsb(aNop_)           ;       \L  ;           
    db lsb(aNop_)           ;       \M  ;            
    db lsb(newln_)          ;       \N  ; new line          
    db lsb(outPort_)        ;       \O  ; out port          
    db lsb(prnStr_)         ;       \P  ; print string          
    db lsb(quit_)           ;       \Q  ; quit. early return          
    db lsb(aNop_)           ;       \R  ;           
    db lsb(aNop_)           ;       \S  ;           
    db lsb(aNop_)           ;       \T  ;          
    db lsb(aNop_)           ;       \U  ;           
    db lsb(aNop_)           ;       \V  ;           
    db lsb(while_)          ;       \W  ; while          
    db lsb(xor_)            ;       \X  ; xor           
    db lsb(aNop_)           ;       \Y  ;           
    db lsb(aNop_)           ;       \Z  ;           

    ENDDAT 

start:
    ld SP,DSTACK		; start of Mondo
    call init		; setups
    call printStr		; prog count to stack, put code line 235 on stack then call print
    .cstr "Mondo V1.0\r\n"

interpret:
    call prompt

    ld bc,0                 ; load bc with offset into TIB, decide char into tib or execute or control         
    ld (vTIBPtr),bc

interpret2:                     ; calc nesting (a macro might have changed it)
    ld E,0                  ; initilize nesting value
    push bc                 ; save offset into TIB, 
                            ; bc is also the count of chars in TIB
    ld hl,TIB               ; hl is start of TIB
    jr interpret4

interpret3:
    ld A,(hl)               ; A = char in TIB
    inc hl                  ; inc pointer into TIB
    dec bc                  ; dec count of chars in TIB
    call nesting            ; update nesting value

interpret4:
    ld A,C                  ; is count zero?
    or B
    jr NZ, interpret3       ; if not loop
    pop bc                  ; restore offset into TIB
; *******************************************************************         
; Wait for a character from the serial input (keyboard) 
; and store it in the text buffer. Keep accepting characters,
; increasing the instruction pointer bc - until a newline received.
; *******************************************************************

waitchar:   
    call getchar        ; loop around waiting for character from serial port
    cp " "			    ; compare to space
    jr NC,waitchar1		; if >= space, if below 20 set cary flag
    cp NULL             ; is it end of string? null end of string
    jr Z,waitchar4
    cp '\r'             ; carriage return? ascii 13
    jr Z,waitchar3		; if anything else its macro/control 
    ld (vTIBPtr),bc
    cp "\b"             ; ^H
    jr nz, interpret2
    ld a,c
    or b
    jp z, interpret2
    dec bc
    call printStr
    .cstr "\b \b"
    jp interpret2
    
waitchar1:
    ld hl,TIB
    add hl,bc
    ld (hl),A               ; store the character in textbuf
    inc bc
    call putchar            ; echo character to screen
    call nesting
    jr  waitchar            ; wait for next character

waitchar3:
    ld hl,TIB
    add hl,bc
    ld (hl),"\r"            ; store the crlf in textbuf
    inc hl
    ld (hl),"\n"            
    inc hl                  ; ????
    inc bc
    inc bc
    call crlf               ; echo character to screen
    ld a,e                  ; if zero nesting append and ETX after \r
    or a
    jr NZ,waitchar
    ld (hl),ETX             ; store end of text ETX in text buffer 
    inc bc

waitchar4:    
    ld (vTIBPtr),bc
    ld bc,TIB               ; Instructions stored on heap at address HERE, we pressed enter
    dec bc

next:                                
    inc bc                      ;   Increment the IP
    ld A, (bc)                  ;   Get the next character and dispatch
    cp 0                        ;   NUL get least signif byte of address exit_
    ld hl,exit_
    jr z,next1
    cp ETX                      ;   ETX
    ld hl,endTxt 
    jr z,next1
    cp " "+1
    jr c,next
    sub "!"
    ld l,a                      ;       Index into table
    ld H,msb(opcodes)           ;       Start address of jump table         
    ld L,(hl)                   ;       get low jump address
    ld H,msb(page4)             ;       Load H with the 1st page address
next1:
    jp (hl)                     ;       Jump to routine

endTxt:                                
    ld hl,-DSTACK               ;       if too much popped of stack rest stack pointer 
    add hl,SP
    jr NC,endTxt1
    ld SP,DSTACK
endTxt1:
    jp interpret

init:                               
    ld hl,LSTACK
    ld (vLoopSP),hl             ; Loop stack pointer stored in memory
    ld IX,RSTACK
    ld IY,next		            ; IY provides a faster jump to next

    ld hl,altVars               ; init altVars to 0 using LDIR
    ld de,hl
    inc de
    ld (hl),0
    ld bc,26 * 2
    LDIR

    ld hl,BUFFER                ; \a vBufPtr			
    ld (vBufPtr),hl
    ld hl,HEAP                  ; \h vHeapPtr start of the free mem
    ld (vHeapPtr),hl
    ld hl,TIB                   ; \t vTIBPtr			
    ld (vTIBPtr),hl

    ld hl,variables             ; init namespaces to 0 using LDIR
    ld de,hl
    inc de
    ld (hl),0
    ld bc,VARS_SIZE
    LDIR

initOps:
    ld hl, iOpcodes
    ld de, opcodes
    ld bc, 256

initOps1:
    ld A,(hl)
    inc hl
    sla A                     
    ret Z
    jr C, initOps2
    srl A
    ld C,A
    ld B,0
    LDIR
    jr initOps1
    
initOps2:        
    srl A
    ld B,A
    ld A,(hl)
    inc hl
initOps2a:
    ld (de),A
    inc de
    DJNZ initOps2a
    jr initOps1

enter:                              ;=9
    ld hl,bc
    call rpush                  ; save Instruction Pointer
    pop bc
    dec bc
    jp (iy)                    

printStr:                       ;=14
    ex (SP),hl		; swap			
    call putStr		
    inc hl			; inc past null
    ex (SP),hl		; put it back	
    ret

rpush:                              ;=11
    dec IX                  
    ld (IX+0),H
    dec IX
    ld (IX+0),L
    ret

rpop:                               ;=11
    ld L,(IX+0)         
    inc IX              
    ld H,(IX+0)
    inc IX                  
rpop2:
    ret

writeChar:                          ;=5
    ld (hl),A
    inc hl
    jp putchar

; **********************************************************************			 
; Page 3 primitive routines 
; **********************************************************************
    .align $100
page4:

at_:
nop_:       
    jp (iy)             

amper_:        
and:
    pop     de          ;     Bitwise and the top 2 elements of the stack
    pop     hl          ;    
    ld      a,e         ;   
    and     L           ;   
    ld      l,a         ;   
    ld      A,D         ;   
    and     H           ;   
and1:
    ld      h,a         ;   
    push    hl          ;    
    jp (iy)           
    
pipe_:
or_: 		 
    pop     de             ; Bitwise or the top 2 elements of the stack
    pop     hl
    ld      a,e
    or      L
    ld      l,a
    ld      A,D
    or      H
    jr and1

plus_:                           ; Add the top 2 members of the stack
add:
    pop de                 
    inc bc
    cp "+"
    jr nz,add1
    inc de                      
    jp assign0
add1:
    dec bc
    pop hl                 
    add hl,de              
    push hl
    jp carry                             

exit_:
    inc bc			; store offests into a table of bytes, smaller
    ld de,bc                
    call rpop               ; Restore Instruction pointer
    ld bc,hl
    ex de,hl
    jp (hl)
    
star_:         
multiply:
    ld (vTemp1),bc              ; save IP
    pop  de                     ; get second value                    
    pop  bc                     ; get first value
    call mult
    push hl                     ; return lsw
    ld (vRemain),bc             ; return msw in var \r
    ld bc,(vTemp1)              ; restore IP
    jp (iy)

hash_:
arrayAccess:
    pop hl                              ; hl = index  
    pop de                              ; de = array
    ld a,(vByteMode)                   ; a = data width
    dec a
    jr z,arrayAccess1
arrayAccess0:
    add hl,hl                           ; if data width = 2 then double 
arrayAccess1:
    add hl,de                           ; add addr
    jp var1

semi_:
ret:
    call rpop           ; Restore Instruction pointer
    ld bc,hl                
    jp (iy)             

; !                              21
; value _oldValue --            ; uses address in vPointer 15
bang_:
assign:
    pop de                      ; discard last accessed value
    pop de                      ; de = new value
assign0:
    ld hl,(vPointer)            ; hl = pointer
assign1:
    ld (hl),e                   ; ignore byte mode to allow assigning to vByteMode           
    inc hl    
    ld (hl),d
    jp (iy)  

eq_:    
    pop hl
    pop de
    and A              ; reset the carry flag
    sbc hl,de          ; only equality sets hl=0 here
    jr Z, equal
    ld hl, 0
    jr less           ; hl = 1    

gt_:    
    pop de
    pop hl
    jr cmp_
    
lt_:    
    pop hl
    pop de
    
cmp_:   
    and A              ; reset the carry flag
    sbc hl,de          ; only equality sets hl=0 here
    jr Z,less          ; equality returns 0  KB 25/11/21
    ld hl, 0
    jp M,less
equal:  
    inc L              ; hl = 1    
less:     
    push hl
    jp (iy) 

;  Left shift { is multiply by 2		
shl_:       
shl:   
    POP HL                  ; Duplicate the top member of the stack
    ADD HL,HL
    PUSH HL                 ; shift left fallthrough into add_     
    JP (IY)                 ;   

;  Right shift } is a divide by 2		
shr_:       
shr:    
    POP HL                  ; Get the top member of the stack
shr1:
    SRL H
    RR L
    PUSH HL
    JP (IY)                 ;   

; [                             
lbrack_:
lbrack:
arrayStart:
    ld hl,0
    add hl,sp
    call rpush                  ; save data stack pointer 
    jp (iy)

grave_:
printLiteral:                                ;=15                      
    inc bc

printLiteral1:            
    ld A, (bc)
    inc bc
    cp "`"                      ; ` is the string terminator
    jr Z,printLiteral2
    call putchar
    jr printLiteral1
    
printLiteral2:  
    dec bc
    jp   (IY) 

slash_: 
slash:                                ;=34
    pop  de                     ; get first value
    pop  hl                     ; get 2nd value
    call div    
    push de                     ; Push Result
    ld (vRemain),hl             ; save remainder in \r
    jp (iy)

var_:
    ld a,(bc)
    call lookupRef
var1:
    ld d,0
    ld e,(hl)
    ld a,(vByteMode)                   
    dec a                       ; is it byte?
    jr z,var2
    inc hl
    ld d,(hl)
var2:
    push de
    jp (iy)

quote_:                         ;= 21
    ld de,(vHeapPtr)        ; hl = heap ptr
    push de                 ; save start of string 
    inc bc                  ; point to next char
    jr strDef2
strDef1:
    ld (de),A
    inc de                  ; increase count
    inc bc                  ; point to next char
strDef2:
    ld A,(bc)
    cp "'"                  ; ` is the string terminator
    jr NZ,strDef1
    xor a                   ; write null to terminate string
    ld (de),A
    inc de
    jp def3

caret_:     jp exec
backslash_: jp alt   
dollar_:    jp dollar
dot_:       jp dot
num_:       jp num
rparen_:    jp rparen		
tilde_:     jp tilde
lparen_:    jp lparen

rbrack_:    jr rbrack
colon_:     jp colon

;*******************************************************************
; Page 4 primitive routines 
;*******************************************************************
    ;falls through 

minus_:
minus:
    inc bc              ; check if sign of a number
    ld a,(bc)
    dec bc
    cp "0"
    jr c,sub
    cp "9"+1
    jp c,num    
sub:       		        ; Subtract the value 2nd on stack from top of stack 
    pop de              ;    
    inc bc
    cp "-"
    jr nz,sub1
    dec de                      
    jp assign0
sub1:
    dec bc
    pop hl              ;      Entry point for INVert
sub2:   
    and A               ;      Entry point for NEGate
    sbc hl,de            
    push hl                 
    jp carry               

; ]
rbrack:
arrayEnd:                       
    ld (vTemp1),bc              ; save IP
    call rpop                   
    ld de,hl                    ; de = hl = SP0
    or a 
    sbc hl,sp                   ; bc = count (items on stack)
    srl h                        
    rr l                        
    ld bc,hl                    
    ld hl,(vHeapPtr)            ; hl = array[-2]
    ld (hl),c                   ; write num items in length word
    inc hl
    ld (hl),b
    inc hl                      
    ex de,hl                    ; hl = SP0, de = array[0], bc = count
    ld sp,hl                    ; sp = SP0
    jr arrayEnd3
arrayEnd1:                        
    dec hl                      ; move to next word on stack
    dec hl
    ld a,(hl)                   ; a = lsb of stack item
    ld (de),a                   ; write lsb of array item
    inc de                      ; move to byte in array
    ld a,(vByteMode)            ; vByteMode = TRUE ? 
    dec a
    jr z,arrayEnd2
    inc hl                      ; move to previous byte on stack
    ld a,(hl)                   ; a = msb of stack item
    dec hl 
    ld (de),a                   ; write msb of array item
    inc de                      ; move to next byte in array
arrayEnd2:
    dec bc                      ; count--
arrayEnd3:
    ld a,c                      ; if not zero loop
    or b
    jr nz,arrayEnd1
    ld hl,(vHeapPtr)            ; de = end of array, hl = array[-2]
    ld (vHeapPtr),de            ; move heap* to end of array
    inc hl                      ; return array[0]
    inc hl
    push hl                     
    ld bc,(vTemp1)              ; restore IP
    jp (iy)

colon:                          ; Create a colon definition
def:
    inc bc
    ld  a,(bc)                  ; Get the next character
    cp " "                      ; if :: then anonymous def
    jr nz,def0
    inc bc
    ld de,(vHeapPtr)            ; start of defintion
    push de
    jp def1
def0:    
    call lookupRef
    ld de,(vHeapPtr)            ; start of defintion
    ld (hl),e                   ; Save low byte of address in CFA
    inc hl              
    ld (hl),d                   ; Save high byte of address in CFA+1
    inc bc
def1:                           ; Skip to end of definition   
    ld a,(bc)                   ; Get the next character
    inc bc                      ; Point to next character
    ld (de),a
    inc de
    cp ";"                      ; compare with delimiter
    jr Z, def2                  ; end the definition
    jr  def1                    ; get the next element
def2:    
    dec bc
def3:
    ld (vHeapPtr),de            ; bump heap ptr to after definiton
    jp (iy)       

lparen:                         ; Left parentheses begins a loop
begin:
    pop hl
    ld a,l                      ; zero?
    or H
    jr Z,begin1
    push IX
    ld IX,(vLoopSP)
    ld de,-6
    add IX,de
    ld (IX+0),0                 ; loop var
    ld (IX+1),0                 
    ld (IX+2),L                 ; loop limit
    ld (IX+3),H                 
    ld (IX+4),C                 ; loop address
    ld (IX+5),B                 
    ld (vLoopSP),IX
    pop IX
    jp (iy)
begin1:
    ld E,1
begin2:
    inc bc
    ld A,(bc)
    call nesting
    xor a
    or e
    jr NZ,begin2
    ld hl,1
begin3:
    inc bc
    ld A,(bc)
    dec bc
    cp "("
    jr NZ,begin4
    push hl
begin4:        
    jp (iy)

rparen:                              ;=72
again:
    push IX
    ld IX,(vLoopSP)
    ld E,(IX+0)                 ; peek loop var
    ld D,(IX+1)                 
    ld L,(IX+2)                 ; peek loop limit
    ld H,(IX+3)                 
    dec hl
    or a
    sbc hl,de
    jr Z,again2
    inc de
    ld (IX+0),E                 ; poke loop var
    ld (IX+1),D                 
again1:
    ld C,(IX+4)                 ; peek loop address
    ld B,(IX+5)                 
    jr again4
again2:   
    ld de,6                     ; drop loop frame
again3:
    add IX,de
again4:
    ld (vLoopSP),IX
    pop IX
    ld hl,0                     ; skip ELSE clause
    jr begin3               

; **************************************************************************
; Page 5 Alt primitives
; **************************************************************************
    .align $100
page5:

; array* -- num     
arrayLength_:
    pop hl
    dec hl                      ; msb size 
    ld d,(hl)
    dec hl                      ; lsb size 
    ld e,(hl)
    push de
    jp (iy)

togByteMode_:
    ld hl,vByteMode
    ld (vPointer),hl
    jp toggle0

hexadecimal_:
    ld hl,TRUE
    jr decimal2
decimal_:
    ld hl,FALSE
decimal2:    
    ld (vHexMode),hl
    jp (iy)
    
while_:
    pop hl
    ld a,l                      ; zero?
    or H
    jr Z,while1
    jp (iy)
while1:
    ld de,6                     ; drop loop frame
    add IX,de
    jp begin1                   ; skip to end of loop        

comment_:
    inc bc                      ; point to next char
    ld A,(bc)
    cp "\r"                     ; terminate at cr 
    jr NZ,comment_
    dec bc
aNop_:
    jp   (IY) 

prnChar_:
    pop hl
    ld a,l
    call putchar
    jp (iy)

go_:
    call go1
    jp (iy)
go1:
    pop hl
    ex (SP),hl
    jp (hl)

prompt_:
    call prompt
    jp (iy)

inPort_:			    ; \<
    pop hl
    ld A,C
    ld C,L
    IN L,(C)
    ld H,0
    ld C,A
    push hl
    jp (iy)        

key_:
    call getchar
    ld H,0
    ld l,a
    push hl
    jp (iy)

newln_:
    call crlf
    jp (iy)        

outPort_:
    pop hl
    ld E,C
    ld C,L
    pop hl
    OUT (C),L
    ld C,E
    jp (iy)        

prnStr_:
prnStr:
    pop hl
    call putStr
    jp (iy)

; quit function (early return)
; --
quit_:
    pop hl
    ld a,l
    or H
    jp NZ,semi_
    jp (iy)

xor_:		 
    pop     de              ; Bitwise xor the top 2 elements of the stack
xor1:
    pop     hl
    ld      a,e
    xor     L
    ld      l,a
    ld      A,D
    xor     H
    jp and1

; **************************************************************************
; Page 6 primitive routines continued  (page 7) 
; **************************************************************************
    ; falls through to following page
    
;*******************************************************************
; primitive routines continued
;*******************************************************************
dotNext:
    ld a,(vStrMode)             ; if string mode then exit
    inc a                       
    call nz,flush
    jp (iy)

alt:                                ;=11
    inc bc
    ld A,(bc)
    cp $5C                      ; \ second backslash
    jp z,comment_

    cp "z"+1                    ; if a > z then exit
    jr nc,alt1
    cp "a"                      
    jr nc,altVar
    
    cp "Z"+1                    ; if > Z then exit
    jr nc,alt1
    sub "A"                     ; a - 65
    jr c,alt1                   ; if < A then exit

    ld hl,altCodes
    add a,l
    ld l,a
    ld A,(hl)                   ;       get low jump address
    ld hl,page5
    ld l,a                      
    jp (hl)                     ;       Jump to routine
alt1:
    jp (ix)

; \i and \j are hardwired to loop iterator vars
altVar:
    ld hl,(vLoopSP)
    cp "i"
    jr nz,altVar1
    jp altVar3
altVar1:
    cp "j"
    jr nz,altVar2
    ld de,6
    add hl,de
    jp altVar3
altVar2:
    ld A,(bc)
    sub "a" 
    add a,a
    ld hl,altVars
    add a,l
    ld l,a
altVar3:
    ld (vPointer),hl
    jp var1

exec:				                    
    pop de
exec1:
    ld A,D                      ; skip if destination address is null
    or e
    jr Z,exec3
    ld hl,bc
    inc bc                      ; read next char from source
    ld A,(bc)                   ; if ; to tail call optimise
    cp ";"                      ; by jumping to rather than calling destination
    jr Z,exec2
    call rpush                  ; save Instruction Pointer
exec2:
    ld bc,de
    dec bc
exec3:
    jp (iy)                     

; 0..9 number                   37
num:
	ld hl,$0000				    ; Clear hl to accept the number
	ld a,(bc)				    ; Get numeral or -
    cp '-'
    jr nz,num0
    inc bc                      ; move to next char, no flags affected
num0:
    ex af,af'                   ; save zero flag = 0 for later
num1:
    ld a,(bc)                   ; read digit    
    sub "0"                     ; less than 0?
    jr c, num2                  ; not a digit, exit loop 
    cp 10                       ; greater that 9?
    jr nc, num2                 ; not a digit, exit loop
    inc bc                      ; inc IP
    ld de,hl                    ; multiply hl * 10
    add hl,hl    
    add hl,hl    
    add hl,de    
    add hl,hl    
    add a,l                     ; add digit in a to hl
    ld l,a
    ld a,0
    adc a,h
    ld h,a
    jr num1 
num2:
    dec bc
    ex af,af'                   ; restore zero flag
    jr nz, num3
    ex de,hl                    ; negate the value of hl
    ld hl,0
    or a                        ; jump to sub2
    sbc hl,de    
num3:
    push hl                     ; Put the number on the stack
    jp (iy)                     ; and process the next character

dollar:
hexnum:        
	ld hl,0	    		        ; Clear hl to accept the number
hexnum1:
    inc bc
    ld a,(bc)		            ; Get the character which is a numeral
    bit 6,a                     ; is it uppercase alpha?
    jr z, hexnum2               ; no a decimal
    sub 7                       ; sub 7  to make $a - $F
hexnum2:
    sub $30                     ; form decimal digit
    jp c,num2
    cp $0F+1
    jp nc,num2
    add hl,hl                   ; 2X ; Multiply digit(s) in hl by 16
    add hl,hl                   ; 4X
    add hl,hl                   ; 8X
    add hl,hl                   ; 16X     
    add a,l                     ; add into bottom of hl
    ld  l,a        
    jr  hexnum1

; . print decimal
; value --                      
dot:
printNumber:        
    ld a,(vHexMode)
    dec a
    jp z,printHex              ; else falls through
    exx
    pop hl                      ; hl = value
    call putDec
    jp dotNext
printHex:                      
    pop hl                      ; hl = value
    call putHex
    jp dotNext

; ~ toggle
; -- 
tilde:
toggle:
    pop de                  ; de = value
toggle0:
    ld a,e
    or d
    jr z,toggle1
    ld de,-1
toggle1:    
    inc de
    ld hl,(vPointer)
    ld (hl),e
    inc hl
    ld (hl),d
toggle2:    
    jp (iy)

;*******************************************************************
; Subroutines
;*******************************************************************

prompt:                             ;=9
    call printStr
    .cstr "\r\n> "
    ret

putStr0:
    call putchar
    inc hl
putStr:
    ld A,(hl)
    cp "\b"                         ; if < 8 terminate
    jr nc,putStr0
    ret

crlf:                               ;=7
    call printStr
    .cstr "\r\n"
    ret

; hl = value
; de = buffer*
; a, bc, de, hl destroyed
formatDec0:    
    push hl
    exx
    pop hl
; hl = value
; de' = buffer*
; a, bc, de, hl destroyed
formatDec:    
    bit 7,h
    jr z,formatDec2
    exx
    ld a,'-'
    ld (de),a
    inc de
    exx
    xor a  
    sub l  
    ld l,a
    sbc a,a  
    sub h  
    ld h,a
formatDec2:        
    ld c,0                      ; leading zeros flag = false
    ld de,-10000
    call formatDec4
    ld de,-1000
    call formatDec4
    ld de,-100
    call formatDec4
    ld e,-10
    call formatDec4
    inc c                       ; flag = true for at least digit
    ld e,-1
    call formatDec4
    ret
formatDec4:	     
    ld b,'0'-1
formatDec5:	    
    inc b
    add hl,de
    jr c,formatDec5
    sbc hl,de
    ld a,'0'
    cp b
    jr nz,formatDec6
    xor a
    or c
    ret z
    jr formatDec7
formatDec6:	    
    inc c
formatDec7:	    
    ld a,b
    exx
    ld (de),a
    inc de
    exx
    ret

; de = first value hl = 2nd value
; return de = result hl = remainder

div:
    push bc                     ; Preserve the IP
    ld B,H                      ; bc = 2nd value
    ld C,L		
	
    ld hl,0    	                ; Zero the remainder
    ld A,16    	                ; Loop counter
div1:		                    ; shift the bits from bc (numerator) into hl (accumulator)
    sla C
    RL B
    adc hl,hl

    sbc hl,de		            ; Check if remainder >= denominator (hl>=de)
    jr C,div2
    inc C
    jr div3
div2:		                    ; remainder is not >= denominator, so we have to add de back to hl
    add hl,de
div3:
    dec A
    jr NZ,div1
    ld D,B                      ; Result from bc to de
    ld E,C
div4:    
    pop  bc                     ; Restore the IP
    ret

; calculate nesting value
; A is char to be tested, 
; E is the nesting value (initially 0)
; E is increased by ( and [ 
; E is decreased by ) and ]
; E has its bit 7 toggled by `
; limited to 127 levels

nesting:                        ;=44
    cp '`'
    jr NZ,nesting1
    bit 7,E
    jr Z,nesting1a
    RES 7,E
    ret
nesting1a: 
    SET 7,E
    ret
nesting1:
    bit 7,E             
    ret NZ             
    cp ':'
    jr Z,nesting2
    cp '['
    jr Z,nesting2
    cp '('
    jr NZ,nesting3
nesting2:
    inc E
    ret
nesting3:
    cp ';'
    jr Z,nesting4
    cp ']'
    jr Z,nesting4
    cp ')'
    ret NZ
nesting4:
    dec E
    ret 

; a = name of variableA..Z,a..z
; returns: hl = address of variable
; clears carry flag if invalid name

lookupRef:
    ld e,0                      ; offset 0
lookupRef0:
    cp "z"+1                    ; if a > z then exit
    jp nc,error1
    cp "a"                      
    jr c,lookupRef1
    sub "a"
    ld e,26*2                   ; offset = 26 words
    jr lookupRef3        
lookupRef1:
    cp "Z"+1                    ; if > Z then exit
    jp nc,error1
    sub "A"
    jp c,error1
lookupRef3:
    add a,a                     ; a *= 2
    add a,e                     ; a += offset
    ld hl,variables             ; hl = variables
    add a,l                     ; hl += a
    ld l,a
    ld a,0
    adc a,h
    ld h,a
    ld (vPointer),hl            ; store address in pointer    
    scf
    ret

; hl = number
putHex:                      
    ld de,(vBufPtr)
    ld a,"$"
    ld (de),a
    inc de                      ; string*++, 
putHex1:
    ld a,(vByteMode)
    dec a
    jr z,putHex2
    ld a,h
    call putHex3
putHex2:
    ld a,l
    call putHex3
    ld a," "                    ; append space to buffer
    ld (de),a
    inc de                      ; string*++, 
    ld (vBufPtr),de
    ret
putHex3:		     
    push af
	rra 
	rra 
	rra 
	rra 
    call putHex4
    pop af
putHex4:		
    and	0x0F
	add	a,0x90
	daa
	adc	a,0x40
	daa
	ld (de),a
    inc de                      ; string*++, 
	ret

; hl = number
putDec:        
    exx                          
    ld de,(vBufPtr)             ; de'= buffer* bc' = IP
    exx                          
    ld a,(vByteMode)
    dec a
    jr nz,printDec1
    ld h,0
printDec1:    
    call formatDec
    exx                         ; de = buffer*' bc = IP
    ld a," "                    ; append space to buffer
    ld (de),a
    inc de                      ; string*++, 
    ld (vBufPtr),de             ; update buffer* with buffer*'
    ret

; hl = error code    
error:
    push hl
    call enter
    db "`Err`.",0
    jp interpret

error1:
    ld hl,1
    jp error

flush:
    ld de,BUFFER
    ld hl,(vBufPtr)
    ld (hl),0                   ; store NUL at end of string
    ld (vBufPtr),de             ; reset vBufPtr to vHeapPtr
    ex de,hl                    ; hl = BUFFER
    call putStr
    ret    

; mult
; multiply 16-bit values (with 32-bit result)
;
; in: Multiply BC with DE
; out: BCHL = result

mult:
    ld a,c
    ld c,b
    ld hl,0
    ld b,16
mult1:
    add hl,hl
    rla
    rl c
    jr nc,mult2
    add hl,de
    adc a,0
    jp nc,mult2
    inc c
mult2:
    djnz mult1
    ld b,c
    ld c,a
    ret

carry:
    ld hl,0
    rl l
    ld (vCarry),hl
    jp (iy)              
