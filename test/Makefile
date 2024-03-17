TEMPPATH = ./temp/
MAKE     = make
NASM     = nasm
EDIMG    = $(TOOLPATH)edimg.exe
COPY     = copy
DEL      = del

all: kernel.bin

kernel.bin: kernel.tmp
	objcopy -O binary -j .text  $(TEMPPATH)kernel.tmp kernel.bin

kernel.tmp: kernel_entry.o kernel.o
	ld -m i386pe -T NUL -o $(TEMPPATH)kernel.tmp -Ttext 0x0000 $(TEMPPATH)kernel_entry.o $(TEMPPATH)kernel.o

kernel.o: kernel.c
	if not exist temp md temp
	gcc -c -fno-builtin -ffreestanding -nostdlib -m32 kernel.c -o $(TEMPPATH)kernel.o

kernel_entry.o: kernel_entry.asm
	if not exist temp md temp
	$(NASM) -felf32 kernel_entry.asm -o $(TEMPPATH)kernel_entry.o

clean :
	if exist temp rd /q /s temp
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.sys
	-$(DEL) *.img
	-$(DEL) *.o