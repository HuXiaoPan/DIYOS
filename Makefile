SRC		 = ./src/
INCLUDES = ./includes/
TOOLPATH = ./Tools/
TEMPPATH = ./temp/
MAKE     = make
NASM     = nasm
GCC		 = gcc
EDIMG    = $(TOOLPATH)edimg.exe
COPY     = copy
DEL      = del

OBJS	 = 	$(TEMPPATH)bootEntry.obj \
			$(TEMPPATH)bootpack.obj \
			$(TEMPPATH)graphic.obj \
			$(TEMPPATH)dsctbl.obj \
			$(TEMPPATH)string.obj \
			$(TEMPPATH)Font.obj \
			$(TEMPPATH)int.obj \
			$(TEMPPATH)fifo.obj \
			$(TEMPPATH)asmfunc.obj

default :
	$(MAKE) -C Tools
	$(MAKE) img

img : hptOS.img
	$(MAKE) hptOS.img

$(TEMPPATH)hptOS.sys: $(TEMPPATH)asmhead.bin $(TEMPPATH)kernel.bin
	cmd /c copy /b .\temp\asmhead.bin+.\temp\kernel.bin .\temp\hptOS.sys

# powershell gc -Encoding Byte $(TEMPPATH)asmhead.bin,$(TEMPPATH)kernel.bin | powershell sc -Encoding Byte hptOS.sys

$(TEMPPATH)kernel.bin: $(TEMPPATH)kernel.tmp
	if not exist temp md temp
	objcopy -O binary -j .data -j .text  -j .bss -j .rdata $(TEMPPATH)kernel.tmp $(TEMPPATH)kernel.bin

$(TEMPPATH)kernel.tmp: $(OBJS)
	if not exist temp md temp
	ld -m i386pe -e _entry -T NUL -Ttext=0x280000 -o $(TEMPPATH)kernel.tmp $(OBJS)

$(TEMPPATH)asmhead.bin: asmhead.asm
	if not exist temp md temp
	$(NASM) -f bin asmhead.asm -o $(TEMPPATH)asmhead.bin -l $(TEMPPATH)asmhead.lst

$(TEMPPATH)bootEntry.obj: bootEntry.asm
	if not exist temp md temp
	$(NASM) -f win32 bootEntry.asm -o $(TEMPPATH)bootEntry.obj -l $(TEMPPATH)bootEntry.lst

$(TEMPPATH)%.obj: $(SRC)%.c
	if not exist temp md temp
	$(GCC) -c -fno-builtin -ffreestanding -nostdlib -m32 -I$(INCLUDES) $(SRC)$*.c -o $(TEMPPATH)$*.obj

$(TEMPPATH)asmfunc.obj: asmfunc.asm
	if not exist temp md temp
	$(NASM) -f win32 asmfunc.asm -o $(TEMPPATH)asmfunc.obj -l $(TEMPPATH)asmfunc.lst

# initial program loader
$(TEMPPATH)ipl.bin : ipl.nas
	if not exist temp md temp
	$(NASM) ipl.nas -o $(TEMPPATH)ipl.bin -l $(TEMPPATH)ipl.lst

# hupan test operator system
#hptOS.sys : hptOS.nas
#	if not exist temp md temp
#	$(NASM) hptOS.nas -o $(TEMPPATH)hptOS.sys -l $(TEMPPATH)hptOS.lst

hptOS.img : $(TEMPPATH)ipl.bin $(TEMPPATH)hptOS.sys
	$(EDIMG)   imgin:disk.tek \
		wbinimg src:$(TEMPPATH)ipl.bin len:512 from:0 to:0 \
		copy from:$(TEMPPATH)hptOS.sys to:@: \
		imgout:hptOS.img

clean :
	$(MAKE) -C Tools clean
	if exist temp rd /q /s temp
	-$(DEL) *.bin
	-$(DEL) *.lst
	-$(DEL) *.sys
	-$(DEL) *.img
	-$(DEL) *.tmp
	-$(DEL) *.obj