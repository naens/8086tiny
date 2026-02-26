.PHONY: all bios 8086tiny clean

OPTS_ALL=-O3 -fsigned-char -std=c99 -Wno-deprecated-declarations

all: bios 8086tiny
bios: bios.asm
	nasm bios.asm -f bin -o bios

8086tiny: 8086tiny.c
	${CC} 8086tiny.c ${OPTS_ALL} -o 8086tiny

clean:
	rm 8086tiny bios
