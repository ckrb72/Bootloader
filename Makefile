BUILD=build

os-image: kernel.bin boot_sect.bin
	cat $(BUILD)/boot_sect.bin $(BUILD)/kernel.bin > $(BUILD)/os-image

kernel.bin: kernel.c kernel_entry.o
	gcc -m32 -ffreestanding -c kernel.c -o $(BUILD)/kernel.o -fno-pie
	ld -o $(BUILD)/kernel.bin -m elf_i386 -Ttext 0x1000 $(BUILD)/kernel_entry.o $(BUILD)/kernel.o --oformat binary

boot_sect.bin: boot_sect.asm
	nasm boot_sect.asm -f bin -o $(BUILD)/boot_sect.bin -i/home/ckrb/projects/systems/kernel/asm

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o $(BUILD)/kernel_entry.o

clean:
	rm $(BUILD)/kernel_entry.o $(BUILD)/kernel.o $(BUILD)/boot_sect.bin $(BUILD)/kernel.bin

run:
	qemu-system-i386 -fda $(BUILD)/os-image

run_compile: os-image
	qemu-system-i386 -fda $(BUILD)/os-image