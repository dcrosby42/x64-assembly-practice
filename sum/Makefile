all: sum
	./sum 40 2

sum.o: sum.asm
	nasm -f elf64 sum.asm

sum: sum.o
	ld -s -o sum sum.o

clean:
	rm -f sum *.o
