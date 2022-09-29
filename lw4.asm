masm
model small

fillRect macro x1, y1, x2, y2, color
	mov ah, 06h
	mov al, 0
	mov bh, color
	mov ch, x1
	mov cl, y1
	mov dh, x2
	mov dl, y2
	int 10h
endm

setCursorAt macro x, y
	push dx
	mov ah, 2
	mov bh, 0
	mov dl, x
	mov dh, y
	int 10h
	pop dx
endm

popupMess macro mess, color
	setCursorAt 15, 9
	fillRect 8, 15, 10, 65, color
	outStr mess
endm

outStr macro str
	mov ah, 9
	lea dx, str
	int 21h
endm

input_str macro buffer
	mov ah, 0Ah
	mov [buffer], LEN
	mov byte ptr [buffer+1], 0
	lea dx, buffer
	int 21h
	mov al, [buffer+1]
	add dx, 2
endm


.data
	LEN = 50
	string1 db LEN + 2 dup(?)
	string2 db LEN + 2 dup(?)
	
	message1 db 'Enter the strings to compare$'
	message2 db 'Down below this text$'
	
	firststrmes db 'First string:$'
	secondstrmes db 'Second string:$'
	
	errormes db 'ERROR: Strings are different after symbol $'
	succmes db 'OK strings are same$'

	newline db 10, 13, '$'
.stack 256

.code
.486

mismatch_output proc

	popupMess errormes, 47h
	
	mov ax, si
	sub ax, 2
	
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

	ret
endp

main:
	mov ax, @data
	mov ds, ax
	
	fillRect 0, 0, 24, 79, 23h
	fillRect 3, 5, 20, 74, 17h
	
	fillRect 14, 15, 14, 64, 02h
	fillRect 18, 15, 18, 64, 02h
	
	setCursorAt 10, 5
	outStr message1
	setCursorAt 10, 6
	outStr message2
	
	setCursorAt 15, 13
	outStr firststrmes
	
	setCursorAt 15, 17
	outStr secondstrmes
	
	setCursorAt 15, 14
	input_str string1
	
	setCursorAt 15, 18
	input_str string2
	
	mov ax, ds
	mov es, ax
	
	xor cx, cx
	
	lea si, string1 + 2
	lea di, string2 + 2
	
	mov al, string1[1]
	mov ah, string2[1]
	cmp al, ah
	ja better
	mov cl, string2[1]
	jmp repeater

better:
	mov cl, string1[1]
	
repeater:
	cld
	add cl, 1
	repz cmpsb
	jcxz success
	
	call mismatch_output
	
	jmp exit
	
success:
	popupMess succmes, 27h
	
exit:
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main