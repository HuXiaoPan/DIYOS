#include "string.h"

const char lut[16] = "0123456789ABCDEF";

string make_string(char *data, int size)
{
	string ret;
	ret.size = size;
	ret.data = data;
	return ret;
}

int int2char(char *data, int size, int tar)
{
	for (int i = size; i > 0; i--)
	{
		int base = 1;
		for (int j = 0; j < i - 1; j++)
		{
			base *= 10;
		}
		data[size - i] = lut[tar / base];
		tar %= base;
	}
	return 0;
}

int getHex(short *data, unsigned char tar)
{
	(*data) = 0;
	char h = lut[(tar >> 4) & 0xF];
	(*data) |= (short)h;
	char l = lut[tar & 0xF];
	(*data) |= (short)l << 8;
	return 0;
}

int char_pushback(string *src, string *tar)
{
	int str_size = char_strlen(src);
	int tar_size = char_strlen(tar);

	for (int i = str_size; (i < src->size) && (i - str_size < tar_size); i++)
	{
		src->data[i] = tar->data[i - str_size];
	}
	return 0;
}

int char_strlen(string *src)
{
	for (int i = 0; i <= src->size; i++)
	{
		if(!src->data[i]) return i;
	}
	return src->size;
}