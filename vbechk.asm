org 100h

	mov ah,9h
	mov dx,hello
	int 21h
	int 20h

hello db 13,10,"Hello, World!$"