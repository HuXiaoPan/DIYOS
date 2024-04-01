#include "bootpack.h"
#include "dsctbl.h"
#include "graphic.h"
#include "string.h"
#include "int.h"
#include "nasfunc.h"

void _main(void)
{
	struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
	init_gdtidt();
	init_pic();
	io_sti(); /* IDT/PIC�̏��������I������̂�CPU�̊��荞�݋֎~������ */

	init_palette();
	char temp[40];
	string s = make_string(temp, 40);
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
	int mx = (binfo->scrnx - 16) / 2; /* 屏幕中心位置 */
	int my = (binfo->scrny - 28 - 16) / 2;
	char mcursor[256];
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
	
	char c1[5] = "(";
	char c2[5] = "";
	char c3[5] = ", ";
	char c4[5] = "";
	char c5[5] = ")";
	string str1 = make_string(c1, 5);
	string str2 = make_string(c2, 5);
	string str3 = make_string(c3, 5);
	string str4 = make_string(c4, 5);
	string str5 = make_string(c5, 5);
	int2char(c2, 3, mx);
	int2char(c4, 3, my);
	char_pushback(&s, &str1);
	char_pushback(&s, &str2);
	char_pushback(&s, &str3);
	char_pushback(&s, &str4);
	char_pushback(&s, &str5);
	putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s.data);

	io_out8(PIC0_IMR, 0xf9); /* PIC1�ƃL�[�{�[�h������(11111001) */
	io_out8(PIC1_IMR, 0xef); /* �}�E�X������(11101111) */

	for (;;)
	{
		io_hlt();
	}
}