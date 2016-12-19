; https://0xax.github.io/asm_3/
; https://github.com/0xAX/asm/blob/master/stack/stack.asm

section .data
	SYS_WRITE	equ 1
	SYS_EXIT	equ 60
	STDOUT		equ 1
	EXIT_CODE	equ 0

	NEW_LINE	db 0xa
	WRONG_ARGC	db "Must be two command line argument", 0xa

section .text
	global	_start

_start:
	;; rcx - argc
	pop	rcx

	;;
	;; Check argc
	;;
	cmp	rcx, 3
	jne	argcError

	;;
	;; start to sum arguments
	;;

	;; skip argv[0] - program name
	; add	rsp, 8
  pop rsi

	;; get argv[1]
	pop	rsi          ; load argv[1] into rsi, the assumed input to str_to_int
	call	str_to_int ; convert string pointed to by rsi into an int value in rax
	mov	r10, rax     ; save resulting int into r10

	pop	rsi          ; load argv[2] into rsi
	call	str_to_int ; convert string to int, store in rax
	mov	r11, rax     ; save results from rax into r11

	add	r10, r11     ; calculate sum of r10 and r11, store in r10

	;;
	;; Convert to string
	;;
	mov	rax, r10     ; rax is the assumed input to int_to_str
	xor	r12, r12     ; clear r12   http://stackoverflow.com/questions/33666617/what-is-the-best-way-to-set-a-register-to-zero-in-x86-assembly-xor-mov-or-and
	jmp	int_to_str   ; dive into the output generator, never to return...

;;
;; Print argc error
;;
argcError:
  ; invoke syscall write() with arg count error message:
	mov	rax, SYS_WRITE
	mov	rdi, STDOUT
	mov	rsi, WRONG_ARGC
	mov	rdx, 34 ; len of err msg
	syscall
	jmp	exit


;;
;; Convert int to string
;;
int_to_str:
	;; reminder from division
	mov	rdx, 0
	;; base
	mov	rbx, 10
	;; rax = rax / 10
	div	rbx
	;; add \0
	add	rdx, 48
	add	rdx, 0x0
	;; push reminder to stack
	push	rdx
	;; go next
	inc	r12
	;; check factor with 0
	cmp	rax, 0x0
	;; loop again
	jne	int_to_str
	;; print result
	jmp	print

;;
;; Convert string to int
;;
str_to_int:
	;; accumulator
	xor	rax, rax
	;; base for multiplication
	mov	rcx,  10
next:
	;; check that it is end of string
	cmp	[rsi], byte 0
	;; return int
	je	return_str
	;; mov current char to bl
	mov	bl, [rsi]
	;; get number
	sub	bl, 48
	;; rax = rax * 10
	mul	rcx
	;; ax = ax + digit
	add	rax, rbx
	;; get next number
	inc	rsi
	;; again
	jmp	next

return_str:
	ret


;;
;; Print number
;;
print:
	;;;; calculate number length
	mov	rax, 1
	mul	r12
	mov	r12, 8
	mul	r12
	mov	rdx, rax
	;;;;

	;;;; print sum
	mov	rax, SYS_WRITE
	mov	rdi, STDOUT
	mov	rsi, rsp
	syscall
	;;

	;; newline
	jmp	printNewline

;;
;; Print newline character
;;
printNewline:
	mov	rax, SYS_WRITE
	mov	rdi, STDOUT
	mov	rsi, NEW_LINE
	mov	rdx, 1
	syscall
	jmp	exit

;;
;; Exit from program
;;
exit:
	mov	rax, SYS_EXIT
	mov	rdi, EXIT_CODE
	syscall
