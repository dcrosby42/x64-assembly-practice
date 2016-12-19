; http://0xax.blogspot.com/2014/08/say-hello-to-x64-assembly-part-1.html
section .data
    msg db      "hello, world!", 0xa

section .text
    global _start

_start:
    mov     rax, 1    ;  sys_write
    mov     rdi, 1    ;  arg1: stdout
    mov     rsi, msg  ;  arg2: char buf
    mov     rdx, 14   ;  arg3: content length
    syscall           ;  execute syscall 

    mov    rax, 60    ;  exit
    mov    rdi, 0     ;  exit status 0
    syscall
