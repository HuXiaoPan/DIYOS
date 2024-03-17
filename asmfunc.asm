; naskfunc
; TAB=4

; [FORMAT "WCOFF"]				; 制作目标文件的模式	
[BITS 32]


; 制作目标文件信息
; [FILE "askfunc.asm"]			; 源文件名称

		GLOBAL	_io_hlt			; 函数符号导出


; 函数定义

[SECTION .text]		; 代码段

_io_hlt:	; void io_hlt(void);
		HLT
		RET
