DEL      = del
GXX		 = g++

All: Font.c

Font.c: CharDataMaker.exe Font.ft
	CharDataMaker.exe -s Font.ft -o ../src/Font.c

CharDataMaker.exe: CharDataMaker.cpp
	$(GXX) -g CharDataMaker.cpp -o CharDataMaker.exe

clean: 
	-$(DEL) CharDataMaker.exe
	-$(DEL) ..\src\Font.c