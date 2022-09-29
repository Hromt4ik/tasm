masm
model small

VMoutput macro string, lend, x, y
	local m1
	mov ax, 0b800h
	mov es, ax
	mov bx, (80*x+y)*2
	lea si, string
	mov cx, lend
m1: 
	mov al, [si]
	mov es:[bx], al
	inc bx
	mov byte ptr es:[bx], 07h
	inc bx
	inc si
loop m1
endm

.data
	text db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
			 db 'chpf!;7~6vc{Rg;6Q3ppt_MFMmn~IxKKL_YEwGAQf,Maq8*TE0'
	len1=$-text
.stack 1000h

.code

.486
main:
	mov ax, @data
	mov ds, ax
	
	mov ax, 600h
	mov cx, 0
	mov dh, 24
	mov dl, 79
	int 10h
	VMoutput text, len1, 0, 0
	
	mov ah, 7
	int 21h

	mov ax, 4c00h
	int 21h
end main