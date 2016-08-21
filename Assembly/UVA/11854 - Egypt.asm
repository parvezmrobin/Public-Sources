;11854 - Egypt 

ORG 100h

.DATA 
RIGHT DB 'right', 10, 13, '$'
WRONG DB 'wrong', 10, 13, '$'

.CODE

MAIN PROC
    START:
    
    CALL SCAN 
    MOV BH, DL
    CALL SCAN
    MOV BL, DL
    CALL SCAN
    MOV CH, DL
    
    CMP BH, 0
    JNE CALC
    CMP BL, 0
    JNE CALC
    CMP CH, 0
    JE ENDMAIN
    
    CALC:
    XOR AX, AX  ;CLEAR AX
    MOV AL, BH
    IMUL AL
    MOV BH, AL
    XOR AX, AX  ;CLEAR AX
    MOV AL, BL
    IMUL AL
    ADD BH, AL
    XOR AX, AX  ;CLEAR AX
    MOV AL, CH
    IMUL AL
    
    CMP AL, BH
    JE PRINTRIGHT
    
    LEA DX, WRONG
    MOV AH, 9
    INT 21H
    JMP START   ;TAKE INPUT AGAIN
    
    PRINTRIGHT:
    LEA DX, RIGHT
    MOV AH, 9
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

  