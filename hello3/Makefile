all: hello

hello.o: hello.asm
	nasm -f elf64 hello.asm

hello: hello.o
	ld -s -o hello hello.o

clean:
	rm -f hello *.o
