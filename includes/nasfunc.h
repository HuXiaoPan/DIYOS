#ifndef NASFUNC_H
#define NASFUNC_H

void io_hlt(void);
// void write_mem8(int addr, int data);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);

#endif // !NASFUNC_H