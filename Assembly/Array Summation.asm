;An Assembly program that shows summtion of an array
;first integer will be the size of array upto 100
;next integers will be the elements of array
;inputs can be separated both by space and new line
org 100h

.DATA
a dw 100 dup(?) ;an array of word of size 100
c db 0          ;variable to store size of array

.CODE
MAIN proc
    call SCAN   ;input size of array
    mov [c], dl ;move the size to c
    
    xor bx, bx
    xor cx, cx
    mov cl, [c]
    INPUTDATA:      ;input array data c times
    call SCAN
    mov a[bx], dx
    add bx, 2
    loop INPUTDATA  ;this will cause iteration cx times
    
    ;print new line
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    
    ;sum data
    xor dx, dx
    xor bx, bx
    xor cx, cx
    mov cl, [c]
    SUM:
    add dx, a[bx]
    add bx, 2
    loop SUM
    
    ;print summation
    mov ax, dx
    call PRINT
    
    ret
MAIN endp

;a procedure that read an integer value
;of one or more digit
;input is terminated by both space and new line
;the inputed integer will be present in dl
SCAN proc       
    mov dx, 0
    INPUT:
    mov ah, 1
    int 21h  
    cmp al, ' '
    je END
    cmp al, 13
    je END
    push ax
    mov al, 10
    mul dl
    mov dl, al
    pop ax
    sub al, '0'
    add dl, al
    jmp INPUT
    END: 
    ret
SCAN endp

;a procedure that prints an integer
;consisting of one or more digits
;the integer must be present in ax
PRINT proc
    xor cx, cx
    LOOP1:
    cwd 
    mov bx, 10
    idiv bx
    push dx
    inc cx
    cmp ax, 0
    jg LOOP1
    
    LOOP2:
    pop dx 
    add dx, '0'
    mov ah, 2
    int 21h
    loop LOOP2  
    ret
PRINT endp    





