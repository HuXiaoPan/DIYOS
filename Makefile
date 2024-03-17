TOOLPATH = ./Tools/
TEMPPATH = ./temp/
MAKE     = make
NASM     = nasm
GCC		 = gcc
EDIMG    = $(TOOLPATH)edimg.exe
COPY     = copy
DEL      = del

default :
	$(MAKE) img

img : hptOS.img
	$(MAKE) hptOS.img

hptOS.sys: kernel.tmp
	objcopy -O binary -j .text $(TEMPPATH)kernel.tmp $(TEMPPATH)hptOS.sys

kernel.tmp: asmhead.obj bootpack.obj asmfunc.obj
	if not exist temp md temp
	ld -m i386pe -T NUL -o $(TEMPPATH)kernel.tmp -Ttext 0xc200 $(TEMPPATH)asmhead.obj $(TEMPPATH)bootpack.obj $(TEMPPATH)asmfunc.obj

asmhead.obj: asmhead.asm
	if not exist temp md temp
	$(NASM) -felf32 .\asmhead.asm -o $(TEMPPATH)asmhead.obj

bootpack.obj: bootpack.c
	if not exist temp md temp
	$(GCC) -c -fno-builtin -ffreestanding -nostdlib -m32 bootpack.c -o $(TEMPPATH)bootpack.obj

asmfunc.obj: asmfunc.asm
	if not exist temp md temp
	$(NASM) -felf32 .\asmfunc.asm -o $(TEMPPATH)asmfunc.obj

# initial program loader
ipl.bin : ipl.nas
	if not exist temp md temp
	$(NASM) ipl.nas -o $(TEMPPATH)ipl.bin -l $(TEMPPATH)ipl.lst

# hupan test operator system
#hptOS.sys : hptOS.nas
#	if not exist temp md temp
#	$(NASM) hptOS.nas -o $(TEMPPATH)hptOS.sys -l $(TEMPPATH)hptOS.lst

hptOS.img : ipl.bin hptOS.sys
	$(EDIMG)   imgin:disk.tek \
		wbinimg src:$(TEMPPATH)ipl.bin len:512 from:0 to:0 \
		copy from:$(TEMPPATH)hptOS.sys to:@: \
		imgout:hptOS.img

clean :
	if exist temp rd /q /s temp
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.sys
	-$(DEL) *.img