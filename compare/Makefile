all: compare

compare.o: compare.asm
	nasm -f elf64 compare.asm

compare: compare.o
	ld -s -o compare compare.o

clean:
	rm -f compare *.o
