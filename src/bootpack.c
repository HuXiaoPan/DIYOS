#include "bootpack.h"

void _main(void)
{

	// short *binfo_scrnx = (short *) 0x0ff4;
	// short *binfo_scrny = (short *) 0x0ff6;;
	// int *binfo_vram= (int *) 0x0ff8;
	// char *p = (char *) 0xa0000;
	init_gdtidt();
	init_palette();
	
	// boxfill8(p, 320, COL8_FF0000,  20,  20, 120, 120);
	// boxfill8(p, 320, COL8_00FF00,  70,  50, 170, 150);
	// boxfill8(p, 320, COL8_0000FF, 120,  80, 220, 180);

	// char *vram = (char *) *binfo_vram;
	// int xsize = *binfo_scrnx;
	// int ysize = *binfo_scrny;

	struct BOOTINFO *binfo = (struct BOOTINFO *) 0x0ff0;
	// char temp[40] = "scrnx = ";
	char temp[40];
	string s = make_string(temp, 40);
	// static char font_A[16] =
	// {
	// 	0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24,
	// 	0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00
	// };

	// char *vram = (*binfo).vram;
	// int xsize = (*binfo).scrnx;
	// int ysize = (*binfo).scrny;

	// init_screen(vram, xsize, ysize);
	init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
	int mx = (binfo->scrnx - 16) / 2; /* 屏幕中心位置 */
	int my = (binfo->scrny - 28 - 16) / 2;
	char mcursor[256];
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
	// putfont8(binfo->vram, binfo->scrnx, 10, 10, COL8_FFFFFF, font_A);
	// putfont8(binfo->vram, binfo->scrnx,  8, 8, COL8_FFFFFF, font + 'A' * 16);
	// putfont8(binfo->vram, binfo->scrnx, 16, 8, COL8_FFFFFF, font + 'B' * 16);
	// putfont8(binfo->vram, binfo->scrnx, 24, 8, COL8_FFFFFF, font + 'C' * 16);
	// putfont8(binfo->vram, binfo->scrnx, 40, 8, COL8_FFFFFF, font + '1' * 16);
	// putfont8(binfo->vram, binfo->scrnx, 48, 8, COL8_FFFFFF, font + '2' * 16);
	// putfont8(binfo->vram, binfo->scrnx, 56, 8, COL8_FFFFFF, font + '3' * 16);
	// putfonts8_asc(binfo->vram, binfo->scrnx,  8,  8, COL8_FFFFFF, "ABC 123");
	// putfonts8_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_000000, "HupanTest OS.");
	// putfonts8_asc(binfo->vram, binfo->scrnx, 30, 30, COL8_FFFFFF, "HupanTest OS.");
	
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


	for (;;)
	{
		io_hlt();
	}
}