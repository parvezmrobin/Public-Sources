;11879 - Multiple of 17

ORG 100h

.DATA
input DB 1002 dup(?) 
yes DB '1', 10, 13, '$'
no DB '0', 10, 13, '$'

.CODE

MOV AX, @DATA
MOV DS, AX

TESTCASE:
        
    MOV SI, 0
    MOV CX, 0
    MOV AH, 1
    INT 21h
    CMP AL, '0'
    JE ENDCASE
    
    INPUTLOOP:
        MOV SI[input], AL
        INC SI
        INT 21h
        CMP AL, 13
        JZ ENDINPUT
        JMP INPUTLOOP
    ENDINPUT:
    MOV SI[input], 36
    
    MOV CX, SI
    DEC CX    
    XOR AX, AX
    MOV AL, 0[input]
    SUB AL, 30h 
    MOV SI, 1
    CMP CX, 1
    JL COMP
    DIVISION:
    	
  		MOV BX, 10	;muliplier
    	IMUL BX
	    ADD AL, SI[input]
	    INC SI 
	    SUB AL, 30h
	    CWD 		;clear DX for division
  		MOV BX, 17	;divisor
  		IDIV BX
  		MOV AX, DX
    	
    LOOP DIVISION:
     
    COMP:
    CMP DX, 0
    JZ PRINTYES
    
    MOV AH, 9
    LEA DX, no
    INT 21h
    JMP TESTCASE
    
    PRINTYES:
    MOV AH, 9
    LEA DX, yes
    INT 21h
    JMP TESTCASE
    	    
ENDCASE:  
RET