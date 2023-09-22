[org 0x7C00]
KERNEL_OFFSET equ 0x1000			; This is the memory offset to which we will load our kernel

mov [BOOT_DRIVE], dl				; BIOS stores our boot drive in DL, so it's best to remember this for later


mov bp, 0x9000						; Set up the stack
mov sp, bp

mov bx, MSG_REAL_MODE				; Sanity check to annouce we are in real mode
call print_string

mov bx, ENDL
call print_string

call load_kernel                    ; Load the kernel

mov bx, KERNEL_LOADED
call print_string

mov bx, ENDL
call print_string

call switch_to_pm                   ; Switch to protected mode, from which we will not return

jmp $

%include "asm/print_string.asm"
%include "asm/disk_load.asm"
%include "asm/gdt.asm"
%include "asm/print_string_pm.asm"
%include "asm/switch_to_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

    mov bx, ENDL
    call print_string
    
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    call KERNEL_OFFSET

    jmp $


MSG_REAL_MODE: db 'Started in 16-bit real mode...', 0
MSG_LOAD_KERNEL: db 'Loading kernel into memory...', 0
MSG_PROT_MODE: db 'Successfully landed in 32-bit Protected Mode...', 0
KERNEL_LOADED: db 'Kernel Loaded Successfully...'
ENDL: db 0x0D, 0x0A, 0
BOOT_DRIVE: db 0

times 510-($-$$) db 0
dw 0xAA55
