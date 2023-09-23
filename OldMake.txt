BUILD=build

all: $(BUILD)/os-image

$(BUILD)/os-image: $(BUILD)/kernel.bin $(BUILD)/boot_sect.bin
	cat $(BUILD)/boot_sect.bin $(BUILD)/kernel.bin > $(BUILD)/os-image

# $^ is substituted with all of th target's dependency files
$(BUILD)/kernel.bin: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o
	ld -o $(BUILD)/kernel.bin -m elf_i386 -Ttext 0x1000 $^ --oformat binary

# $< is the first dependency and $@ is the target file
$(BUILD)/kernel.o: kernel.c
	gcc -m32 -ffreestanding -c $< -o $@ -fno-pie

$(BUILD)/boot_sect.bin: boot_sect.asm
	nasm $< -f bin -o $@ -i/home/ckrb/projects/systems/kernel/asm

$(BUILD)/kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

clean:
	rm -fr $(BUILD)/*.bin $(BUILD)/*.o $(BUILD)/*.dis

run: all
	qemu-system-i386 -fda $(BUILD)/os-image

clean_all:
	rm -fr $(BUILD)/*.bin $(BUILD)/*.o $(BUILD)/os-image $(BUILD)/*.dis

disasm: $(BUILD)/kernel.bin
	ndisasm -b 32 $< > $(BUILD)/kernel.dis