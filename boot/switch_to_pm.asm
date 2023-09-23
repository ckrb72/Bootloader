[bits 16]

switch_to_pm:

	mov bx, SWITCH_PM_MSG
	call print_string
	
	cli						; Tells the cpu to ignore interrupts until we enable them again

	lgdt [gdt_descriptor]	; load the gdt descriptor table, which defines the protected mode
							; segments (e.g. for code and data)

	mov eax, cr0			; To make the switch to protected mode, we set the first bit of CRO, a control register
	or eax, 0x1
	mov cr0, eax

	; Now in 32-bit mode but need to flush the cpu

	jmp CODE_SEG:init_pm

[bits 32]

init_pm:
	; 32-bit code

	mov ax, DATA_SEG		; Now in Protected Mode, our old segments are meaningless,
	mov ds, ax				; so we point our segment registers to the data selector we defined in our GDT
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000		; Update our stack position so it is right at the top of the free space
	mov esp, ebp


	jmp BEGIN_PM			; Finally, call a label with Protected Mode code

SWITCH_PM_MSG: db 'Entering switch_to_pm', 0