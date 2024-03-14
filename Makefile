TOOLPATH = ./Tools/
TEMPPATH = ./temp/
MAKE     = $(TOOLPATH)make.exe
NASM     = nasm
EDIMG    = $(TOOLPATH)edimg.exe
COPY     = copy
DEL      = del

default :
	$(MAKE) img

img : hptOS.img
	$(MAKE) hptOS.img

# initial program loader
ipl.bin : ipl.nas
	if not exist temp md temp
	$(NASM) ipl.nas -o $(TEMPPATH)ipl.bin -l $(TEMPPATH)ipl.lst

# hupan test operator system
hptOS.sys : hptOS.nas
	if not exist temp md temp
	$(NASM) hptOS.nas -o $(TEMPPATH)hptOS.sys -l $(TEMPPATH)hptOS.lst

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