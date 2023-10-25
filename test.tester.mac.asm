.macro tester, test1, expect1
    DB "`.`\\U3\\t!"
    DB " ",test1," "
    DB "K\\U3\\t!"                          ; ( -- hash1 )
    DB " ",expect1," "
    DB "K=0=(\\N`fail: ",test1," expected: "
    DB expect1,"`\\N\\N",0,")"
.endm
