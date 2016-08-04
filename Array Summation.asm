org 100h

.DATA
a dw 100 dup(?)
c db 0 

.CODE
MAIN proc
    call SCAN   ;input size of array
    mov [c], dl
    
    xor bx, bx
    xor cx, cx
    mov cl, [c]
    INPUTDATA:      ;input array data
    call SCAN
    mov a[bx], dx
    add bx, 2
    loop INPUTDATA
    
    xor dx, dx
    xor bx, bx
    xor cx, cx
    mov cl, [c]
    SUM:
    add dx, a[bx]
    add bx, 2
    loop SUM
    
    mov ax, dx
    call PRINT
    
    ret
MAIN endp


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





