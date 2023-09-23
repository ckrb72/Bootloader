[bits 16]
print_string:
	pusha
	mov ah, 0x0E
	
print_loop:	
	mov al, [bx]
	cmp al, 0
	je print_done
	int 0x10
	add bx, 1
	jmp print_loop

print_done:
	popa
	ret
