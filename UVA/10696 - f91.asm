;10696 - f91

ORG 100h

MAIN PROC
    START:
    CALL SCAN   ;TAKE INPUT IN DL
    CMP DL, 0
    JE ENDMAIN  ;IF DL = 0, TERMINATE
    
    ;COMPARE 
    CMP DL, 100
    JG GREATER
    MOV DL, 91  
    JMP RESULT
    
    GREATER:
    SUB DL, 10
    
    RESULT:
    MOV AX, 0
    MOV AL, DL
    CALL PRINT
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
    
    JMP START   ;TAKE INPUT AGAIN
    ENDMAIN:

    RET
MAIN ENDP

;a procedure that read an integer value
;of one or more digit
;input is terminated by both space and new line
;the inputed integer will be present in dl
SCAN PROC       
    MOV DX, 0
    INPUT:
    MOV AH, 1
    INT 21h  
    CMP AL, ' '
    JE END
    CMP AL, 13
    JE END
    PUSH AX
    MOV AL, 10
    MUL DL
    MOV DL, AL
    POP AX
    SUB AL, '0'
    ADD DL, AL
    JMP INPUT
    END: 
    RET
SCAN ENDP 


;a procedure that prints an integer
;consisting of one or more digits
;the integer must be present in ax
PRINT PROC
    XOR CX, CX
    LOOP1:
    CWD 
    MOV BX, 10
    IDIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JG LOOP1
    
    LOOP2:
    POP DX 
    ADD DX, '0'
    MOV AH, 2
    INT 21h
    LOOP LOOP2  
    RET
PRINT ENDP    
