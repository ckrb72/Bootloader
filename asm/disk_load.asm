[bits 16]

disk_load:
    push dx

    mov ah, 0x02        ; BIOS Flag for reading
    mov al, dh          ; read dh sectors
    mov ch, 0x00        ; select cylinder 0
    mov dh, 0x00        ; select head 0
    mov cl, 0x02        ; start reading from the second sector (i. e. after the boot sector)

    int 0x13            ; BIOS interrupt to read disk

    jc disk_error       ; Jump if error

    pop dx
    cmp dh, al
    jne disk_error
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG: db 'Disk read error!', 0