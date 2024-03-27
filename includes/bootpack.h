#ifndef BOOTPACK_H
#define BOOTPACK_H

#include "dsctbl.h"
#include "graphic.h"
#include "string.h"
#include "int.h"

/* asmhead.nas */
struct BOOTINFO { /* 0x0ff0-0x0fff */
	char cyls; /* 启动区读硬盘读到何处停止 */
	char leds; /* 启动时键盘灯状态 */
	char vmode; /* 显卡模式为多少位色彩 */
	char reserve;
	short scrnx, scrny; /* 画面分辨率 */
	char *vram;
};
#define ADR_BOOTINFO	0x00000ff0

extern void _main(void);

#endif // BOOTPACK_H