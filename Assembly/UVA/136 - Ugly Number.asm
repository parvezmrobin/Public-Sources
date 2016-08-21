;136 - Ugly Number

ORG 100h
.DATA
UN DB 'The 1500', 39,'th ugly number is 859963392.', 10, 13, '$'

.CODE
MOV AX, @DATA
MOV DS, AX
LEA DX, UN
MOV AH, 9
INT 21H

RET




