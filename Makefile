

os-image: kernel.bin boot_sect.bin
	cat boot_sect.bin kernel.bin > os-image

kernel.bin: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o -fno-pie
	ld -o kernel.bin -m elf_i386 -Ttext 0x1000 kernel.o --oformat binary

boot_sect.bin: boot_sect.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin -i/home/ckrb/projects/systems/kernel/asm

clean:
	rm kernel.o boot_sect.bin kernel.bin

run: os-image
	qemu-system-i386 -fda os-image