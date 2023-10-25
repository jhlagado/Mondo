.macro expect,msg1,val1
    pop hl
    push hl
    ld de,val1
    or A
    sbc hl,de
    ld A,L
    or H
    jr Z,expect%%M
    pop hl
    call printStr
    .cstr msg1,"\r\nActual: "
    call putDec
    call flush
    call printStr
    .cstr "\r\nExpected: "
    ld hl,val1
    call putDec
    call flush
    halt
    .cstr
expect%%M:
    pop hl
.endm

.macro test,code1,val1
    call enter
    .cstr code1
    expect code1,val1
.endm
