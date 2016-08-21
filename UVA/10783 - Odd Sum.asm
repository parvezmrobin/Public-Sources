;10783 - Odd Sum

ORG 100h

MAIN PROC
    CALL SCAN   ;INPUT TESTCASE
    MOV CX, 0   ;CLEAR CX
    MOV CL, DL
    MOV AH, 2
    MOV DL, 10  ;PRINT NEW LINE
    INT 21H
    MOV DL, 13  ;PRINT CARRIEG RETURN 
    INT 21H
    TESTCASE:
    PUSH CX
        CALL SCAN
        MOV BL, DL
        CALL SCAN
        MOV BH, DL
        ;INCREAMENT BL IF POSITIVE
        MOV CH, BL
        AND CH, 1
        JNZ JUMP1
        INC BL
        JUMP1: 
        ;DECREAMENT BH IF POSITIVE
        MOV CH, BH
        AND CH, 1
        JNZ JUMP2
        DEC BH
        JUMP2:
        
        ;SUMMATION
        MOV AX, 0   ;CLEAR AX
        SUMMATION:
        ADD AL, BL
        ADD BL, 2
        CMP BL, BH
        JLE SUMMATION
        
        ;PRINT VALUE AT AL
        CALL PRINT
        MOV AH, 2
        MOV DL, 10  ;PRINT NEW LINE
        INT 21H
        MOV DL, 13  ;PRINT CARRIEG RETURN 
        INT 21H
    POP CX
    LOOP TESTCASE
    
    
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
