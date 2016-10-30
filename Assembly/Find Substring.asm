;An assembly program that search for a substring
;Outputs the position of substring if found

ORG 100h

.DATA
str 	DB  100 dup(?)
substr  DB  100 dup(?)

infst   DB  'Enter string: $'
insnd   DB  'Enter substring: $' 

start   DW  ?
stop    DW  ?
sublen  DW  ?
             
msgfnd  DB  'Found at position $'
msgnfnd DB  'Not found$'

.CODE
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
    MOV AH, 9
    LEA DX, infst
    INT 21h
    
    LEA DI, str
    CALL READSTRING
    PUSH CX     ;Store length of string in stack
    
    CALL NEWLINE
    
    LEA DX, insnd
    INT 21h
    
    LEA DI, substr
    CALL READSTRING
    MOV sublen, CX
    OR CX, CX
    JZ NOTFOUND ;If length of substring is zero, then not found
    POP CX      ;Restore length of string in CX
    
    CALL NEWLINE
    
    OR CX, CX
    JZ NOTFOUND ;If length of string is zero, then not found
    CMP sublen, CX
    JG NOTFOUND ;If substring is larger that string, then not found
    
    ;Load source and destination index
    LEA SI, substr
    LEA DI, str
    
    CLD
    
    ;Calculate stop
    MOV stop, DI
    ADD stop, CX
    MOV CX, sublen
    SUB stop, CX   
    
    MOV start, DI
    WHILE:
        MOV CX, sublen
        MOV DI, start
        LEA SI, substr
        ;Repeat CX times while value of SI and DI is same
        REPE CMPSB
        JE FOUND    ;If all are equal, then substring found at DI
        
        INC start
        
        MOV AX, start
        CMP AX, stop
        JG NOTFOUND
    JMP WHILE
    ENDWHILE:
    
    FOUND:
        LEA DX, msgfnd
        MOV AH, 9
        INT 21h
        ;Calculate position
        MOV AX, start
        LEA DI, str
        SUB AX, DI
        CALL PRINT
        
        JMP END 
    NOTFOUND:
        LEA DX, msgnfnd
        MOV AH, 9
        INT 21h 
    END:    
RET

;A procedure that reads and stores a string in 
;memory address stored in DI, and its length in CX
READSTRING PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH DI
    
    CLD
    XOR CX, CX
    MOV AH, 1
    INT 21h
    
    RSWHILE:
        CMP AL, 13
        JE RSENDWHILE
        
        CMP AL, 8
        JE BACKSPACE
        
        STOSB
        INC CX
        JMP READNEXT
        
        BACKSPACE:
        DEC DI
        DEC CX         
        
        READNEXT:
        INT 21h
        
    JMP RSWHILE
    RSENDWHILE:
    
    POP DI
    POP DX
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

; A procedure that prints number stored in AX in decimal format
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
