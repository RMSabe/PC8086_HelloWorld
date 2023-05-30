HOLDTIME equ 0x01800000

org 0x7c00
bits 16

mov ah, 0x0
mov al, 0x3
int 0x10

mov ax, 0x7000
mov ss, ax
mov bp, 0x1000
mov sp, bp

mov ax, 0xb800
mov es, ax
mov di, 0x0

mov ah, 0x0
mov cx, 0x0

sysloop:
	mov sp, bp
	mov bx, $
	push bx
	push string
	jmp print
	times 8 nop	;Yes, these 8 NOPs (No operand instruction) are a "landing area" for when returning to the sysloop routine
	add cx, 0xa0
	cmp cx, 0xfa0
	mov sp, bp
	mov bx, $
	push bx
	je resetline
	times 8 nop	;Same thing here
	inc ah
	mov sp, bp
	mov bx, $
	push bx
	jmp hold
	times 8 nop	;Same thing here
	jmp sysloop

print:
	mov di, cx
	pop bx
	printloop:
	mov al, [bx]
	cmp al, 0x0
	je printend
	mov [es:di], ax
	inc bx
	add di, 0x2
	jmp printloop
	printend:
	pop bx
	add bx, 0x6
	jmp bx

resetline:
	mov cx, 0x0
	pop bx
	add bx, 0x8
	jmp bx

hold:
	mov ebx, 0x0
	holdloop:
	cmp ebx, HOLDTIME
	je holdend
	inc ebx
	jmp holdloop
	holdend:
	mov ebx, 0x0
	pop bx
	add bx, 0x6
	jmp bx

string: db 'Hello World', 0x0

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

