; Makes a string representation of a number
; in: 1) number
; out: AX - string length
utoa:
	push bx
	push si

	; counting digits
	mov bx, sp
	mov ax, [bx+6]
	xor si, si
	.digits:
	xor dx, dx
	inc si
	div word [const_10]
	test ax, ax
	jnz .digits

	; writing end line character
	add si, ufroma
	mov byte [si], '$'

	; converting number to string
	mov ax, [bx+6]
	.write_str:
	xor dx, dx
	dec si
	div word [const_10]
	add dx, '0'
	mov [si], dl
	test ax, ax
	jnz .write_str
    
	pop si
	pop bx
	ret

const_10 dw 10
ufroma db 6 dup 0
