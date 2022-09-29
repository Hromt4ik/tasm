masm
model small

outStr macro str
	mov ah, 9
	lea dx, str
	int 21h
endm

.data
	LEN = 50
	number db LEN dup(?)

	message1 db 'Enter the number:$'
	sizemes db 'Length of number: $'

	errormes db 'There are no numbers!$'

	newline db 10, 13, '$'
.stack 256

.code

.486

bcd_input proc
; В регистре BX хранится эффективный адрес BCD числа
; В нулевом байте регистра BX записывается кол-во введённых символов

	outStr message1
	outStr newline

	xor cx, cx
	mov cl, LEN
	mov si, cx

inLoop:
	mov ah, 1
	int 21h

	cmp al, 13
	je exit

	sub al, 30h
	mov [bx][si], al
	dec si
	inc byte ptr[bx]
loop inLoop

exit:
	ret
endp

bcd_output proc
; В регистре BX хранится эффекстивный адрес BCD числа
; Которого нам нужно вывести

	cmp byte ptr[bx], 0
	je errorOut

	outStr newline

	xor cx, cx
	xor cl, [bx]
	mov si, LEN

outNum:
	mov ah, 2
	mov dl, [bx][si]
	dec si
	add dl, 30h
	int 21h
loop outNum

	outStr newline
	outStr sizemes

	xor ax, ax

	mov al, [bx]
	aam
	or ax, 3030h

	mov dx, ax
	mov ah, 2
	xchg dl, dh
	cmp dl, 30h
	je m3
	int 21h
m3:
	xchg dl, dh
	int 21h

quit:
	ret

errorOut:
	outStr errormes
	jmp quit

endp

main:
	mov ax, @data
	mov ds, ax

	lea bx, number
	call bcd_input

	lea bx, number
	call bcd_output

	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main