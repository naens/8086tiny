.PHONY: all border clean

OPTS_ALL=-O3 -fsigned-char -std=c99 -Wno-deprecated-declarations

all: bios.bin 8086tiny border.bin


bios.bin: bios.asm
	nasm bios.asm -f bin -o bios.bin

8086tiny: 8086tiny.c
	${CC} 8086tiny.c ${OPTS_ALL} -o 8086tiny

border.bin: border.asm
	nasm border.asm -f bin -o border.bin

border: border.bin 8086tiny bios.bin
	./8086tiny bios.bin border.bin

clean:
	rm 8086tiny bios.bin border.bin
