;11727 - Cost Cutting

ORG 100H
.DATA
msg1 DB 'Case $'
msg2 DB ': $'
nl DB 10, 13, '$'

.CODE
MAIN PROC
	MOV AX, @DATA
	MOV DS, AX
	  
    CALL SCAN		;Testcase
    MOV CX, AX
    MOV AX, 1
    TESTCASE:
    PUSH CX
    PUSH AX
       	CALL SCAN
       	MOV CX, AX
       	CALL SCAN
       	MOV BX, AX
       	CALL SCAN
       	
       	CMP AX, BX
       	JG AXG
       	CMP BX, CX
       	JG AXCX
       	MOV DX, BX	;CX > BX > AX
       	JMP DONE
       	AXCX:		;BX > AX, CX
       	CMP AX, CX
       	JL CXMID	
       	MOV DX, AX	;BX > AX > CX
       	JMP DONE
       	CXMID:		;BX > CX > AX
       	MOV DX, CX
       	JMP DONE
       	AXG:
       	CMP AX, CX
       	JG BXCX
       	MOV DX, AX	;CX > AX > BX
       	JMP DONE
       	BXCX:		;AX > BX, CX
       	CMP BX, CX
       	JL CXMID
       	MOV DX, BX	;AX > BX > CX
       	
       	DONE:
       	MOV CX, DX	;CX holds result
       	MOV AH, 9
       	LEA DX, msg1
       	INT 21h
       	
       	POP AX
       	CALL PRINT
       	INC AX
       	PUSH AX
       	
       	MOV AH, 9
       	LEA DX, msg2
       	INT 21h
       	
       	MOV AX, CX
       	CALL PRINT
       	
       	MOV AH, 9
       	LEA DX, nl
       	INT 21h
       	
       	POP AX
       	
    POP CX
    LOOP TESTCASE
    RET
ENDP

;A procedure that reads a 16 bit signed input
;and store that in AX
SCAN PROC
    ;Backup register values in stack
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;Clear register values
    XOR BX, BX
    XOR CX, CX
    
    ;Read first character
    MOV AH, 1
    INT 21H
    
    ;Check if it is a sign or digit
    CMP AL, '-'
    JE NEGATIVE
    CMP AL, '+'
    JE POSITIVE
    JMP INPUTSCAN
    
    NEGATIVE:
    ;Store that it is negative number in CX
    MOV CX, 1
    
    POSITIVE:
    ;Take a digit input if first input is sign
    INT 21H
    
    INPUTSCAN:
    ;Convert the digit ASCII to number
    AND AX, 000FH
    ;As multiplication erases value in AX
    ;backup the digit to stack
    PUSH AX
    ;Multiply previous value by 10 and add new value
    MOV AX, 10
    MUL BX
    ;Pop new digit from stack
    POP BX
    ADD BX, AX 
    ;Read digit repeatedly until space or carriage return read
    MOV AH, 1
    INT 21H
    CMP AL, ' '
    JE ENDINPUT
	CMP AL, -1
	JE ENDINPUT
    CMP AL, 13
    JE CARRIAGERETURN
    JMP INPUTSCAN
    
    CARRIAGERETURN:
    ;If last input is carriage return, print a new line
    MOV AH, 2
    MOV DL, 10
    INT 21H
    
    ;Store the positive input to AX
    ENDINPUT:
    MOV AX, BX   
    
    ;Check if the value is negative
    CMP CX, 0
    JE ENDSCAN
    NEG AX
    
    ENDSCAN:
    ;Restore register values from stack
    POP DX
    POP CX
    POP BX
    RET
ENDP
  
PRINT PROC
    ;Backup register values in stack
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;Check if Ax is positive or negative
    CMP AX, 0
    JGE INIT
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX
    
    INIT:
    XOR CX, CX  ;Clear CX. Holds number of digits
    MOV BX, 10  ;Holds divisor
    
    DIGITIFY:
    CWD         ;Clear DX
    DIV BX
    PUSH DX     ;Push last digit to stack
    INC CX
    
    ;Check if the quotient is zero
    CMP AX, 0
    JNZ DIGITIFY
    
    ;Pop and print
    MOV AH, 2
    PRINTLOOP:
    POP DX
    OR DL, 30H  ;Convert to ASCII
    INT 21H
    LOOP PRINTLOOP
    
    ;Restore register values from stack
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ENDP
