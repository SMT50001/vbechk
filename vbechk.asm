include 'macros.inc'
; Using cdecl calling convention
use16
org 100h

	; getting VBE info structure
	push es
	mov ax, 0x4F00
	mov di, vbe_info
	int 0x10
	pop es
	cmp ax, 0x004F
	jne vbe_not_supported

	; printing VBE version
	cdecl print_string, message_version
	mov bx, [vbe_info.version]
	movzx ax, bh
	cdecl print_number, ax
	cdecl print_char, '.'
	movzx ax, bl
	cdecl print_number, ax

	cdecl print_string, message_modes

	; reading video modes
	mov fs, word [vbe_info.video_modes+2]
	mov si, word [vbe_info.video_modes]
	
	xor bx, bx
	xor dx, dx
	list_modes:

	; getting mode info
	mov ax, 0x4F01
	mov cx, [fs:si+bx]
	add bx, 2
	cmp cx, 0xFFFF
	je list_modes_end
	mov di, vbe_mode_info
	int 0x10
	cmp ax, 0x004F
	jne bios_err

	; printing mode info
	push dx
	cdecl print_number, [vbe_mode_info.width]
	cdecl print_char, 'x'
	cdecl print_number, [vbe_mode_info.height]
	cdecl print_char, 'x'
	movzx ax, byte [vbe_mode_info.bpp]
	cdecl print_number, ax
	pop dx

	; printing N modes in one line
	inc dx
	cmp dx, 5 ; how many modes do we print?
	je print_n_modes_newline
	push dx
	cdecl print_string, comma_and_space
	pop dx
	jmp print_n_modes_end
	print_n_modes_newline:
	push dx
	cdecl print_string, newline
	pop dx
	xor dx, dx
	print_n_modes_end:
	
	jmp list_modes

	list_modes_end:

	jmp exit

	vbe_not_supported:
	cdecl print_string, error_vbe_not_supported
	jmp exit

	bios_err:
	cdecl print_string, error_bios

	exit:
	int 20h

print_number:
	push bx
	mov bx, sp
	cdecl utoa, [bx+4]
	mov ah, 0x9
	mov dx, ufroma
	int 21h
	pop bx
	ret

print_string:
	push bx
	mov ah, 0x9
	mov bx, sp
	mov dx, [bx+4]
	int 21h
	pop bx
	ret

print_char:
	push bx
	mov ah, 0x2
	mov bx, sp
	mov dx, [bx+4]
	int 21h
	pop bx
	ret

include 'util.inc'

newline db 13,10,'$'
comma_and_space db ", $"
message_version db "Supported VBE version: $"
message_modes db 13,10,"Supported modes:",13,10,'$'
error_vbe_not_supported db "Error: VBE is not supported$"
error_bios db "BIOS error$"

vbe_info:
.signature db "VBE2"
.version dw 0
.oem dd 0
.capabilities dd 0
.video_modes dd 0
.video_memory dw 0
.software_rev dw 0
.vendor dd 0
.product_name dd 0
.product_rev dd 0
.reserved db 222 dup 0
.oem_data db 256 dup 0

vbe_mode_info:
.attributes dw 0
.window_a db 0
.window_b db 0
.granularity dw 0
.window_size dw 0
.segment_a dw 0
.segment_b dw 0
.win_func_ptr dd 0
.pitch dw 0
.width dw 0
.height dw 0
.w_char db 0
.y_char db 0
.planes db 0
.bpp db 0
.banks db 0
.memory_model db 0
.bank_size db 0
.image_pages db 0
.reserved0 db 0
.red_mask db 0
.red_position db 0
.green_mask db 0
.green_position db 0
.blue_mask db 0
.blue_position db 0
.reserved_mask db 0
.reserved_position db 0
.direct_color_attributes db 0
.framebuffer dd 0
.off_screen_mem_off dd 0
.off_screen_mem_size dw 0
.reserved1 db 206 dup 0
