;11479 - Is this the easiest problem

ORG 100h 

.DATA
INV DB 'Invalid$'
EQU DB 'Equilateral$'
ISO DB 'Isosceles$'
SCA DB 'Scalene$'
NL DB 10, 13, '$'

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    CALL SCAN       ;INPUT TEST CASE 
    MOV CX, 0       ;CLEAR CX   
    MOV CL, DL
    
    TESTCASE:
    PUSH CX
        ;INPUT THREE SIDES
        CALL SCAN   
        MOV BH, DL
        CALL SCAN
        MOV BL, DL
        CALL SCAN
        MOV CH, DL
        
        ;CHECK IF INVALID
        XOR AX, AX  ;CLEAR AX
        MOV AL, BH
        ADD AL, BL
        CMP AL, CH
        JL Invalid
        
        XOR AX, AX  ;CLEAR AX
        MOV AL, BH
        ADD AL, CH
        CMP AL, BL
        JL Invalid
        
        XOR AX, AX  ;CLEAR AX
        MOV AL, CH
        ADD AL, BL
        CMP AL, BH
        JL Invalid
        
        ;COMPARE THE SIDES
        CMP BH, BL
        JNE NEQUAL
        CMP BH, CH
        JE Equilateral  ;EVERY SIDE IS EQUAL
        JNE Isosceles   ;JUST BH AND BL ARE EQUAL
        
        NEQUAL:
        CMP BH, CH
        JE Isosceles    ;JUST BH AND CH ARE EQUAL
        CMP BL, CH
        JE Isosceles    ;JUST BL AND CH ARE EQUAL
        JMP Scalene     ;NONE OF THEM ARE EQUAL
        
        ;OUTPUT
        Invalid:
        MOV AH, 9
        LEA DX, INV
        INT 21H
        JMP NEWLINE
        
        Equilateral:
        MOV AH, 9
        LEA DX, EQU
        INT 21H
        JMP NEWLINE
        
        Isosceles:
        MOV AH, 9
        LEA DX, ISO
        INT 21H
        JMP NEWLINE 
        
        Scalene:
        MOV AH, 9
        LEA DX, SCA
        INT 21H
        
        NEWLINE:
        LEA DX, NL
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

