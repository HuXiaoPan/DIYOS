; naskfunc
; TAB=4

; [FORMAT "WCOFF"]				; 制作目标文件的模式	
; [INSTRSET "i486p"]			;


; 制作目标文件信息
; [FILE "askfunc.asm"]			; 源文件名称

		GLOBAL	_io_hlt,_write_mem8		; 函数符号导出


; 函数定义

[SECTION .text]		; 代码段

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_write_mem8:	; void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4]		; [ESP]中存放的是地址，将其读入ecx
		MOV		AL,[ESP+8]		; [ESP+4]中存放的是数据，将其读入al
		MOV		[ECX],AL
		RET