;This program calculates summation of rows,
;summation of columns, average of rows,
;average of columns of an nXm sized 2D array
;where n*m must be less or equal to 100
 
ORG 100H
.DATA
n		DW	?
m		DW	?
a		DW	100	dup(?)
rsum	DW	20	dup(?)
csum	DW	20	dup(?)
ravg	DW	20	dup(?)
cavg	DW	20	dup(?)
rsize	DW 	? 
strrs	DB 'Row Summation: $'
strcs	DB 'Column Summation: $'
strra	DB 'Row Average: $'
strca	DB 'Column Average: $'

.CODE
MAIN PROC
	MOV AX, @DATA
	MOV DS, AX
	  
    CALL SCAN
    MOV n, AX	;Number of rows
    CALL scan 
    MOV m, AX	;Number of columns
    
    ;Size of word row = 2 * number of elements
    MOV rsize, AX
    SHL rsize, 1	
    
    ;Input
    MOV CX, n 
    XOR BX, BX	;BX holds offset of row
    INFOROUTER:
    PUSH CX
    	XOR SI, SI	;SI holds index of elements
    	MOV CX, m    	
    	INFORINNER:
    		CALL scan
    		MOV a[BX + SI], AX
    		ADD SI, 2
    	LOOP INFORINNER
    ADD BX, rsize	;BX points to next row 
    POP CX
    LOOP INFOROUTER 
    
    ;Row summation
    MOV CX, n
    XOR BX, BX
    ROWFOROUTER:
    PUSH CX
    	MOV CX, m
    	XOR SI, SI	;SI holds index of elements
    	XOR AX, AX	;AX holds the summation
    	ROWFORINNER:
    		ADD AX, a[BX + SI]	
    	ADD SI, 2
    	LOOP ROWFORINNER
    	
    	PUSH BX
    	PUSH AX		;Push sumation to stack
    	;BX holds row offset
    	;row index = row offset / size of row
    	MOV AX, BX
    	CWD 
    	IDIV rsize	;AX holds the row index
    	MOV BX, AX  
    	;For word array index must be multiplied by 2
    	SHL BX, 1	
    	POP AX		;Pop summation from stack 
    	
    	MOV rsum[BX], AX
    	CWD
    	IDIV m		;AX holds the average
    	MOV ravg[BX], AX
    	POP BX
    		
    ADD BX, rsize
    POP CX
    LOOP ROWFOROUTER
    
    
    ;Column Summation
    MOV CX, m
    XOR BX, BX	;BX holds index of element
    COLFOROUTER:
    PUSH CX
    	MOV CX, n
    	XOR SI, SI	;SI holds column offset
    	XOR AX, AX	;AX holds the summation
    	COLFORINNER:
    		ADD AX, a[BX+SI]
    	ADD SI, rsize
    	LOOP COLFORINNER
    	
    	MOV csum[BX], AX
    	CWD
    	IDIV n
    	MOV cavg[BX], AX
    	
    ADD BX, 2
    POP CX
    LOOP COLFOROUTER 
    CALL NEWLINE
    
    ;Print results
    MOV AH, 9
    
    LEA DX, strrs
    INT 21h
    LEA SI, rsum
    MOV CX, n
    CALL PRINTARRAY
    CALL NEWLINE
    
    LEA DX, strcs
    INT 21h
    LEA SI, csum
    MOV CX, m
    CALL PRINTARRAY
    CALL NEWLINE
    
    LEA DX, strra
    INT 21h
    LEA SI, ravg
    MOV CX, n
    CALL PRINTARRAY
    CALL NEWLINE
    
    LEA DX, strca
    INT 21h
    LEA SI, cavg
    MOV CX, m
    CALL PRINTARRAY
    CALL NEWLINE
    
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

;Print the elements of an word array separated by space
;SI holds offset address
;CX holds number of elements
PRINTARRAY PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	
	PRINTARRAYFOR:
		MOV AX, [SI]
		CALL PRINT
		ADD SI, 2
		MOV DL, ' '
		MOV AH, 2
		INT 21h
	LOOP PRINTARRAYFOR
	
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET	
ENDP


;Prints a new line
NEWLINE PROC
	PUSH AX
	PUSH DX
	MOV AH, 2
	MOV DL, 10
	INT 21h
	
	MOV DL, 13
	INT 21h
	
	POP DX
	POP AX
	RET
ENDP
