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
	setCursorAt 32, 14
	fillRect 12, 27, 16, 50, color
	outStr mess
endm

outStr macro message
	mov ah, 9
	lea dx, message
	int 21h
endm

VMoutput macro string, lend, x, y
	local m1
	mov ax, 0b800h
	mov es, ax
	mov bx, (80*x+y)*2
	lea si, string
	mov cx, lend
m1: 
	mov al, [si]
	mov es:[bx],al
	inc bx
	mov byte ptr es:[bx],4eh
	inc bx
	inc si
loop m1
endm

.data
	LEN = 50
	password_buf db LEN + 1 dup(?)	
	
	password db 'test123'
	passlen=$-password
	
	message1 db 'Enter the password'
	len1=$-message1
	
	message2 db 'Below this text'
	len2=$-message2
	
	grantedMes db 'ACCESS GRANTED$'
	deniedMes db 'ACCESS DENIED$'
.stack 256

.code

password_input proc
; Buffer writes by BX register

fillBuffer:
	xor cx, cx
	xor si, si
	
	mov cl, LEN

	inc si

inLoop:
	mov ah, 8
	int 21h

	cmp al, 13
	je exit
	
	cmp al, 27
	je startover
	
	cmp al, 8
	je cutSym

	mov [bx][si], al
	inc si
	inc byte ptr[bx]

	mov ah, 02h
	mov dl, '*'
    int 21h
loop inLoop

exit:
	ret
	
startover:
	xor cx, cx
	xor si, si
	
	mov cl, LEN
clearloop:
	mov byte ptr[bx][si], 00h
	inc si
loop clearloop

	fillRect 14, 15, 14, 64, 07h
	setCursorAt 15, 14

	jmp fillBuffer
	
cutSym:	
	lea dx, [bx][1]
	cmp si, dx
	je cut 
	dec si
cut:
	xor dx, dx
	
	mov dx, [bx]
	cmp dx, 00h
	je skip
	
	mov dh, 14

	mov dl, 15
	add dl, [bx]
	dec dl
    	mov ah, 2h      
    	int 10h
	
	mov ah, 02h
	mov dl, ' '
    	int 21h
	
	mov dl, 15
	add dl, [bx]
	dec dl
	mov ah, 2h      
    	int 10h
	
	mov byte ptr[bx][si], 00h
	dec byte ptr[bx]
	inc cx
	
skip:
	jmp inLoop

endp

.486
main:
	mov ax, @data
	mov ds, ax
	
	fillRect 3, 5, 20, 74, 47h
	setCursorAt 10, 5
	VMoutput message1, len1, 5, 30
	VMoutput message2, len2, 6, 32
	
	fillRect 14, 15, 14, 64, 07h
	setCursorAt 15, 14
	
	lea bx, password_buf
	call password_input
	
	mov ax, ds
	mov es, ax
	
	xor cx, cx
	xor ax, ax
	
	lea si, password_buf + 1
	lea di, password
	
	mov al, password_buf[0]
	mov ah, passlen
	cmp al, ah
	ja better
	jmp deniedPop

better:
	mov cl, password_buf[0]
	
repeater:
	cld
	repz cmpsb
	jcxz success
	
deniedPop:
	popupMess deniedMes, 47h
	
	jmp quit
	
success:
	popupMess grantedMes, 27h
	
quit:
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main