;12577 - Hajj-e-Akbar

ORG 100H

.DATA
Hajj DB 'Hajj-e-Akbar', 10, 13, '$'
Umrah DB 'Hajj-e-Asghar', 10, 13, '$'

.CODE 

MAIN PROC
    START:
    MOV AH, 1
    INT 21H
    MOV BL, AL
    HUDDAI:
    INT 21H
    CMP AL, 13
    JNE HUDDAI
    
    CMP BL, '*'
    JE ENDMAIN
    CMP BL, 'H'
    JE AKBAR
    
    LEA DX, UMRAH
    MOV AH, 9
    INT 21H
    JMP START
    
    AKBAR:
    LEA DX, Hajj
    MOV AH, 9
    INT 21H
    JMP START
    
    ENDMAIN:
    RET
ENDP

