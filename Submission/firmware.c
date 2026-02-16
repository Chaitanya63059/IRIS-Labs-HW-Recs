#include <stdint.h>
#include <stdbool.h>
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)

/*---------Define your data processing registers addresses here -----------------*/
#define REG_MODE        (*(volatile uint32_t*)0x03000000)
#define REG_STATUS      (*(volatile uint32_t*)0x03000004)
#define REG_PIXEL_OUT   (*(volatile uint32_t*)0x03000008)
/*---------------------------------------------------------------------------------*/

void putchar(char c);
void print(const char *p);
void print_hex(uint8_t v);

void main()
{
	reg_uart_clkdiv = 104;
	
	// Mode 0: Bypass
	REG_MODE = 0;
	for (int i = 0; i < 1024; i++) {
		while (!(REG_STATUS & 0x01));
		uint8_t out = (uint8_t)REG_PIXEL_OUT;
		print_hex(out);
		putchar(' ');
		if ((i + 1) % 32 == 0) putchar('\n');
	}
	
	// Mode 1: Invert
	REG_MODE = 1;
	for (int i = 0; i < 1024; i++) {
		while (!(REG_STATUS & 0x01));
		uint8_t out = (uint8_t)REG_PIXEL_OUT;
		print_hex(out);
		putchar(' ');
		if ((i + 1) % 32 == 0) putchar('\n');
	}
	
	// Mode 2: Convolution
	REG_MODE = 2;
	for (int i = 0; i < 1024; i++) {
		while (!(REG_STATUS & 0x01));
		uint8_t out = (uint8_t)REG_PIXEL_OUT;
		print_hex(out);
		putchar(' ');
		if ((i + 1) % 32 == 0) putchar('\n');
	}
}

void print_hex(uint8_t v)
{
	char hex[] = "0123456789ABCDEF";
	putchar(hex[(v >> 4) & 0xF]);
	putchar(hex[v & 0xF]);
}

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}
