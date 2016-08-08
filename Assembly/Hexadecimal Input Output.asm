; Written with IBM 8086 standerd
; This program can only handle hexadecimal digit 

org 100h

MAIN proc
    ;Reads a hexadecimal number 
    ;from console and store it in bx
    CALL HEXSCAN
    ;Write a hexadecimal number
    ;stored in bx to console     
    CALL HEXPRINT
    ;return control to OS
    ret
    
endp MAIN

HEXSCAN proc 
    
    mov bl, 0   ;Clear value in BX
    TOPS:
    mov ah, 1
    int 21h     ;Read a character from console
    cmp al, ' '
    je EXIT     ;If the character is space exit inputting
    cmp al, 13
    je EXIT     ;If the character is carriage return exit inputting
    
    shl bx, 4   ;Multiply BX by 16 
    mov ah, 0
    cmp al, '9' 
    ;If the charater is greater than 9
    ;then it is a letter. Jump to associate program line
    jg ABCS     
    
    ;Else handle it as digit
    sub ax, '0'
    add bx, ax
    jmp TOPS
    
    ABCS:
    cmp ax, 'Z'
    ;If the character is greater than Z
    ;then it is small letter
    jg SMALL
    ;Else it is capital letter      
    sub ax, 'A'
    ;Jump to calculation to skip subtraction for small letter
    jmp CALC
    
    SMALL:
    sub ax, 'a'
    CALC:
    add ax, 10
    add bx, ax
    jmp TOPS    ;Jump to top to input next digit 
     
    EXIT:  
    ret         ;return to MAIN procedure
    
endp HEXSCAN   

;this procedure uses stack 
;because while reading from register
;we get LSD first and MSB last
;but we've to print MSB first and LSB last
;stack does this reversal
HEXPRINT proc   
    mov cx, 0   ;Clear CX
    TOPP:
    inc cx      ;Increament CX to store the number of digits
    mov dx, bx  ;Move the value of bx to dx
    ;ANDing a number with 15 keeps only 
    ;the lower 4 bits. Because 15d = 1111b
    and dx, 15
    cmp dx, 9
    ;If the digit is greater than 9
    ;then it is a letter
    jg ABCP:    
    
    ;Else it is a number
    add dx, '0' ;convert the digit to ASCII
    push dx     ;push it to stack
    jmp CHECK
    
    ABCP:
    add dx, 'A' 
    sub dx, 10  ;convert the digit to ASCII
    push dx     ;push it to stack
    
    CHECK:
    shr bx, 4   ;divide bx by 16
    cmp bx, 0   ;Check if bx is zero
    jnz TOPP    ;If not handle next digit
    
    mov ah, 2
    PRINT:
    pop dx
    int 21h     ;pop and print pushed values from stack 
    ;jumps back to PRINT CX times 
    ;which is nunber of values stored in stack
    loop PRINT  
    
    ret         ;return to MAIN procedure
    
endp HEXPRINT

