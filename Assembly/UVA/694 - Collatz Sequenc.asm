;694 - Collatz Sequenc

ORG 100H

.DATA
msg1 DB 'Case $'
msg2 DB ': A = $' 
msg3 DB ', limit = $'
msg4 DB ', number of terms = $'
nl DB 10, 13, '$'

.CODE

MAIN PROC 
	MOV AX, @DATA
	MOV DS, AX
	
	MOV DX, 1
	TESTCASE:
		PUSH DX
	
		CALL SCAN
		MOV BX, AX
		CALL SCAN
		CMP AX, -1
		JE ENDCASE
		
		MOV CX, 1
		PUSH BX
		CALCULATE:
			CMP BX, 1
			JZ ENDCULATE
			CMP BX, AX
			JG LIMIT
			
		    TEST BX, 1
		    JZ EVEN
			    PUSH AX
			    MOV AX, 3
			    IMUL BX
			    ADD AX, 1
			    MOV BX, AX
				POP AX
				JMP INCREAMENT
			EVEN:
				SAR BX, 1
			INCREAMENT:	
			INC CX
		JMP CALCULATE
		LIMIT:
		DEC CX			    
		ENDCULATE:
		
		POP BX 
		POP DX
		PUSH AX
		PUSH DX
		
		MOV AH, 9
		LEA DX, msg1 
		INT 21h
		
		POP AX		;Value of DX
		CALL PRINT 
		PUSH BX
		MOV BX, AX	;BX holds case number
		
		MOV AH, 9
		LEA DX, msg2
		INT 21h
		
		POP AX		;Pops the lower value
		CALL PRINT
		
		MOV AH, 9
		LEA DX, msg3
		INT 21h
		
		POP AX
		CALL PRINT
		
		MOV AH, 9
		LEA DX, msg4
		INT 21h
		
		MOV AX, CX
		CALL PRINT
		
		MOV AH, 9
		LEA DX, nl
		INT 21h
		
		MOV DX, BX
		INC DX        
		JMP TESTCASE
 	ENDCASE:   
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
