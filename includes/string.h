#ifndef STRING_H
#define STRING_H

extern const char lut[16];

typedef struct
{
	int size;
	char *data;
} string;

string make_string(char *data, int size);
int int2char(char *data, int size, int tar);
int getHex(short *data, unsigned char tar);
int char_pushback(string *src, string *tar);
int char_strlen(string *src);

#endif // STRING_H