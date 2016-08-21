;11172 - Relational Operator

ORG 100h

MAIN PROC
    CALL SCAN   ;INPUT TESTCASE
    MOV CX, 0   ;CLEAR CX
    MOV CL, DL
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H
        
    TESTCASE:
    PUSH CX
        CALL SCAN   ;TAKE FIRST INPUT
        MOV BH, DL
        CALL SCAN   ;TAKE SECOND INPUT
        
        MOV AH, 2
         
        MOV BL, DL
        CMP BH, BL
        JG GREATER
        JL LESS
        
        EQUAL:      ;PRINT EQUAL
        MOV DL, '='
        INT 21H
        JMP NEWLINE
        
        GREATER: 
        MOV DL, '>'
        INT 21H
        JMP NEWLINE
          
        LESS:
        MOV DL, '<'
        INT 21H
          
        NEWLINE:
        MOV DL, 10
        INT 21H
        MOV DL, 13
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
