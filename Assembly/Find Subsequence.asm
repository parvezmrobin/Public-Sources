;An assembly program that search for a subsequence 
;in a given string 

ORG 100h

.DATA
str 	DB  100 dup(?)
subsqn  DB  100 dup(?)

infst   DB  'Enter string: $'
insnd   DB  'Enter subsequnce: $' 

start   DW  ?
stop1   DW  ?    
stop2   DW  ?
sublen  DW  ?
             
msgfnd  DB  'Found$'
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
MOV stop1, DI
ADD stop1, CX   ;Ending position of given string   
PUSH CX         ;Store length of string in stack

CALL NEWLINE

LEA DX, insnd
INT 21h

LEA DI, subsqn
CALL READSTRING
MOV stop2, DI
ADD stop2, CX   ;Ending position of sub sequence
MOV sublen, CX
OR CX, CX
JZ NOTFOUND     ;If length of substring is zero, then not found
POP CX          ;Restore length of string in CX

CALL NEWLINE

OR CX, CX
JZ NOTFOUND     ;If length of string is zero, then not found
CMP sublen, CX
JG NOTFOUND     ;If substring is larger that string, then not found

;Load source and destination index
LEA SI, subsqn
LEA DI, str

CLD

MOV start, DI
WHILE:
    LODSB       ;Load a character from subsequnce to AL
    MOV CX, stop1
    SUB CX, DI  ;CX holds how many chars remaining for matching
    REPNZ SCASB ;Repeat scan until not found or DI reaches stop1
    
    JNZ NOTFOUND
    ;If SI reaches stop2, then all characters are found
    CMP SI, stop2
    JGE FOUND
    
    ;If DI reaches stop1, then nothing left for matching. Thus not found.
    CMP DI, stop1
    JGE NOTFOUND
JMP WHILE
ENDWHILE:

FOUND:
    LEA DX, msgfnd
    MOV AH, 9
    INT 21h
    
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

