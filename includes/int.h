#ifndef INT_H
#define INT_H

struct KEYBUF
{
	unsigned char data[32];
	int next_r, next_w, len;
};

void init_pic(void);
void inthandler21(int *esp);
void inthandler2c(int *esp);
void inthandler27(int *esp);

#define ADR_BOOTINFO	0x00000ff0
#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021
#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1

/* asmhead.nas */
struct BOOTINFO { /* 0x0ff0-0x0fff */
	char cyls; /* 启动区读硬盘读到何处停止 */
	char leds; /* 启动时键盘灯状态 */
	char vmode; /* 显卡模式为多少位色彩 */
	char reserve;
	short scrnx, scrny; /* 画面分辨率 */
	char *vram;
};

#endif // !INT_H