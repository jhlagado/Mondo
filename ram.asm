            .ORG RAMSTART

            TIBSIZE     EQU $100		; 256 bytes , along line!
            BUFSIZE     EQU $100
            DSIZE       EQU $80
            RSIZE       EQU $80
            LSIZE       EQU $80
            VARS_SIZE   EQU 26*2*2	    ; A..Z, a..z words

TIB:        DS TIBSIZE                  ; one page

BUFFER:     ds BUFSIZE                  ; one page, lsb of vBufPtr is length and wraps around

            DS RSIZE
rStack:        

            DS DSIZE
dStack:        
stack:
            DS LSIZE
lStack:

            .align $100
opcodes:    
            DS $80 - $22
altCodes:
            DS 26 * 2

            .align $100
MONDOVars:
            DS $30
vLoopSP:    DS 2                ; 
tbPtr:      DS 2                ; reserved for tests

RST08:      DS 2                 
RST10:      DS 2                 
RST18:      DS 2                 
RST20:      DS 2                 
RST28:      DS 2                 
RST30:      DS 2                 
BAUD        DS 2                 
INTVEC:     DS 2                 
NMIVEC:     DS 2                 
GETCVEC:    DS 2                   
PUTCVEC:    DS 2                   

vTemp1      DS 2
vTemp2      DS 2
vTemp3      DS 2

altVars:

vBufPtr:    DS 2                ; a buffer pointer
vByteMode:  DS 2                ; b byte mode
vCarry      DS 2                ; c carry
            DS 2                ; d
vEchoMode:  DS 2                ; e echo mode
            DS 2                ; f
            DS 2                ; g
vHeapPtr:   DS 2                ; h heap ptr
vI:         DS 2                ; i virtual var
vJ:         DS 2                ; j virtual var
            DS 2                ; k
            DS 2                ; l  
            DS 2                ; m  
            DS 2                ; n
            DS 2                ; o
vPointer:   DS 2                ; p pointer 
            DS 2                ; q
vRemain:    DS 2                ; r     
vStrMode:   DS 2                ; s
vTIBPtr:    DS 2                ; t
            DS 2                ; u
            DS 2                ; v
            DS 2                ; w
vHexMode:   DS 2                ; x     
            DS 2                ; y
            DS 2                ; z

variables:
            DS VARS_SIZE

HEAP:         
