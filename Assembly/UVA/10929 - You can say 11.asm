;10929 - You can say 11

ORG 100h

.DATA
input DB 1002 dup(?)
yes DB ' is a multiple of 11', 10, 13, '$'
no DB ' is not a multiple of 11', 10, 13, '$' 

.CODE

MOV AX, @DATA
MOV DX, AX

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
    DEC CX    
    MOV BX, 10	;for multiplication
    XOR AX, AX
    MOV AL, 0[input]
    SUB AL, 30h 
    IMUL BX
    ADD AL, 1[input] 
    SUB AL, 30h
    MOV SI, 2
    CMP CX, 1
    JL COMP
    DIVISION:
    	
  		CWD
  		MOV BX, 11
  		IDIV BX
  		MOV AX, DX
  		MOV BX, 10
  		IMUL BX
  		ADD AL, SI[input]	
  		SUB AL, 30h  		
    	INC SI
    	
    LOOP DIVISION:
     
    COMP:
    PUSH AX
    MOV AH, 9
    LEA DX, input
    INT 21h
    
    POP AX
    MOV BX, 11
    CWD
    IDIV BX
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