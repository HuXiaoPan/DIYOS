; hptos
; TAB=4

CYLS	EQU		10				; cylinders 柱面数量

		ORG		0x7c00			; 段偏移量 

; 以下是标准FAT12格式软盘专用的代码
 
		JMP		SHORT boot
		DB		0x90
		DB		"HUPANIPL"		; 启动扇区名称，任意字节
		DW		512				; 每个扇区（sector）大小，必须为512字节
		DB		1				; 簇（cluster）大小，必须为一个扇区
		DW		1				; FAT的起始位置，一般为第一扇区开始
		DB		2				; FAT的个数，必须为2
		DW		224				; 根目录的大小，一般为224项
		DW		2880			; 该磁盘的大小，必须是2880个扇区
		DB		0xf0			; 磁盘的种类，必须是0xf0
		DW		9				; FAT的长度，必须是9个扇区
		DW		18				; 一个磁道（track）有几个扇区，必须是18
		DW		2				; 磁头数，必须是2
		DD		0				; 不使用分区，必须是0
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 意义不明，固定
		DD		0xffffffff		; （可能是）卷标号码
		DB		"HUPAN-OS"		; 磁盘的名称（11B）
		DB		"FAT12"			; 磁盘格式名称（8B）
		TIMES	18 DB 0			; 空出18B的空间
 
boot:
		MOV		AX,0			; 初始化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; 内存写入起始位置

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; 柱面
		MOV		DH,0			; 磁头
		MOV		CL,2			; 扇区
readloop:
		MOV		SI,0
retry:
		MOV		AH,0x02			; 读盘
		MOV		AL,1			; 一个扇区
		MOV		BX,0
		MOV		DL,0x00			; A驱动器
		INT		0x13			; 磁盘BIOS
		JNC		next
		ADD		SI,1			; 记录错误次数
		CMP		SI,5
		JAE		error			; 五次错误报错
		MOV		AH,0x00
		MOV		DL,0x00			; 复位磁盘驱动器
		INT		0x13			; 中断
		JMP		retry
next:
		MOV		AX,ES
		ADD		AX,0x0020
		MOV		ES,AX			; 下一扇区
		ADD		CL,1			; 
		CMP		CL,18			; 18个扇区全部读完
		JBE		readloop		; 未读完则再读
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		; 磁头计数
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; 柱面计数

		MOV		[0x0ff0],CH
		JMP		0xc200

error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; 下一字符
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; 
		MOV		BX,15			;
		INT		0x10			; 
		JMP		putloop
fin:
		HLT						;
		JMP		fin				; 
msg:
		DB		0x0a, 0x0a		; 
		DB		"load error"
		DB		0x0a			;
		DB		0
 
		TIMES	0x1fe-($ - $$) DB 0	
 
		DB		0x55, 0xaa