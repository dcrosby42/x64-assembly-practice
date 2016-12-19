section .text
  global  _start

_start:
  mov eax,4    ; sys_write
  mov ebx,1    ; stdout
  mov ecx,msg  ; char buf
  mov edx,len  ; length of buffer
  int 0x80     ; execute syscall

  mov eax,1    ; exit
  mov ebx,0    ; exit status code 0
  int 0x80     ; execute syscall

section .data
  msg db 'Hello World!', 0xa  ; hello world plus newline
  len equ $ - msg             ; capture the length
