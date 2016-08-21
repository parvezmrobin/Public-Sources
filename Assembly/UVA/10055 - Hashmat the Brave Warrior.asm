;10055 - Hashmat the Brave Warrior

ORG 100h

.CODE
MAIN PROC 
    START:
    CALL SCAN
    MOV BH, DL  ;move first value in bh
    CALL SCAN 
    MOV BL, DL  ;move second value in bl
    SUB BH, BL  ;SUBTRACT THE INPUT VALUES
    MOV AX, 0   ;CLEAR AX
    MOV AL, BH  ;MOVE SUBTRACTION TO AL FOR PRINT PROC
    CMP AL, 0
    JG P        ;IF SUBTRACTION IS NOT GREATER THAN ZERO
    NEG AL      ;NEGATE SUBTRACTION
    P:
    CALL PRINT
    MOV AH, 2
    MOV DL, 10  ;PRINT NEW LINE
    INT 21H
    MOV DL, 13  ;PRINT CARRIGE RETURN
    INT 21H
    JMP START   ;TAKE INPUT AGAIN
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
