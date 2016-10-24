;12708 - GCD the largest

ORG 100H 

MAIN PROC  
    CALL SCAN
    MOV CX, AX
    
    TESTCASE:
    PUSH CX
        
        CALL SCAN
        MOV CX, 1
        MOV BX, 1	;Initial GCD
        OUTERLOOP:
        CMP CX, AX
        JGE ENDOUTER
        
           MOV DX, CX
           INC DX
           INNERLOOP:
           CMP DX, AX
           JG ENDINNER
           	  CMP CX, DX
           	  JZ CONTINUE  
           	  PUSH AX
           	  CALL GCD
           	  CMP AX, BX
           	  JLE CONTINUE
           	  MOV BX, AX
           CONTINUE:
           POP AX
           INC DX
           JMP INNERLOOP    	
           ENDINNER:
           INC CX
           JMP OUTERLOOP
        ENDOUTER:
        
        MOV AX, BX
        CALL PRINT
        MOV AH, 2
        MOV DL, 10
        INT 21h
        MOV DL, 13
        int 21h
        
    POP CX
    LOOP TESTCASE
    RET
ENDP 

;Stores the GCD of CX & DX in AX
GCD PROC
	PUSH CX
	PUSH DX
	MOV AX, DX
	GCDCALC:
		CWD
		IDIV CX
		OR DX, DX
		JZ ENDGCD
		MOV AX, CX
		MOV CX, DX		
	JMP GCDCALC
	ENDGCD:
	MOV AX, CX	
	POP DX
	POP CX
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
