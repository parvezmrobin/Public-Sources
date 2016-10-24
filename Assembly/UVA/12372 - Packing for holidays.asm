;12372 - Packing for holidays

ORG 100H
.DATA
	CASE DW ?
	A DW ?
	B DW ?
	C DW ?
	msg DB 'case $'
	msg1 DB 'good$'
	msg2 DB 'bad$'   
	
.CODE     

MAIN PROC  
START:
    MOV CASE,0
    MOV AX,@DATA
    MOV DS,AX
    CALL SCAN
    XOR CX,CX
    MOV CX,AX
    LOOP1:
    INC CASE
    CALL SCAN
    MOV A,AX
    CALL SCAN
    MOV B,AX
    CALL SCAN
    MOV C,AX
    CMP A,20
    JLE N1
    JMP BAD
    
N1:
  CMP B,20
  JLE N2
  JMP BAD 
  
N2:
   CMP C,20
   JLE GOOD
   JMP BAD 
   
good:
   MOV AH,9
   LEA DX,msg
   INT 21h
   MOV AX,CASE
   CALL PRINT
   MOV AH,2
   MOV DX,':'
   INT 21h   
   MOV DX,' '
   INT 21h
   MOV AH,9
   LEA DX,msg1
   INT 21h
   MOV AH,2
   MOV DX,10
   INT 21h
   MOV DX,13
   INT 21h
  
   LOOP LOOP1
   MOV AH,2
   MOV DX,10
   INT 21h
   MOV DX,13
   INT 21h
   JMP START
   
BAD:
   MOV AH,9
   LEA DX,msg
   INT 21h
   MOV AX,CASE
   CALL PRINT
   MOV AH,2
   MOV DX,':'
   INT 21h   
   MOV DX,' '
   INT 21h
   MOV AH,9
   LEA DX,msg2
   INT 21h
   MOV AH,2
   MOV DX,10
   INT 21h
   MOV DX,13
   INT 21h
   
   LOOP LOOP1
   MOV AH,2
   MOV DX,10
   INT 21h
   MOV DX,13
   INT 21h
   JMP START
        
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
    JMP INPUT
    
    NEGATIVE:
    ;Store that it is negative number in CX
    MOV CX, 1
    
    POSITIVE:
    ;Take a digit input if first input is sign
    INT 21H
    
    INPUT:
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
    CMP AL, 13
    JE CARRIAGERETURN
    JMP INPUT
    
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