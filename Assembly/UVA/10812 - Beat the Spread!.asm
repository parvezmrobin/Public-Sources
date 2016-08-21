;10812 - Beat the Spread!

ORG 100h

.DATA
IMP DB 'impossible', '$'
NL DB 10, 13, '$' 
A DB ?
B DB ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    CALL SCAN   ;INPUT TESTCASE
    MOV CX, 0   ;CLEAR CX
    MOV CL, DL
    LEA DX, NL
    MOV AH, 9
    INT 21H
    
    TESTCASE:
    PUSH CX
        CALL SCAN   ;INPUT SUM
        MOV [A], DL
        CALL SCAN   ;INPUT DIFF
        MOV [B], DL
        CMP [A], DL
        ;IF SUM IS LESS THAN DIFF, IMPOSSIBLE
        JL IMPOSSIBLE
        MOV CX, 0   ;CLEAR CX
        ADD CL, [A]
        ADD CL, [B]
        AND CL, 1
        ;IF SUM OF SUM AND DIFF IS ODD, IMPOSSIBLE
        JNZ IMPOSSIBLE
        CWD
        MOV AX, 0
        ADD AL, [A]
        ADD AL, [B]
        MOV CX, 2
        IDIV CX     ;DIVIDE AL BY 2
        CALL PRINT  ;PRINT GREATER NUMBER STORED IN AL
         
        MOV DL, ' '
        INT 21H     ;PRINT SPACE
        
        CWD
        MOV AX, 0
        MOV AL, [A]
        SUB AL, [B] 
        MOV CX, 2
        IDIV CX     ;DIVIDE AL BY 2
        CALL PRINT  ;PRINT SMALLER NUMBER STORED IN AL
        
        JMP NEWLINE
        
        IMPOSSIBLE:
        LEA DX, IMP
        MOV AH, 9
        INT 21H
        
        NEWLINE:
        LEA DX, NL
        MOV AH, 9
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