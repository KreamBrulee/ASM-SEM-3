;Kunal Shitole
;123B!B136
;Assignment 2

;----------------------------------------------------------------------------------------------------------------------------------------
section .data
	msg db "Hello world",10
	new db "Welcome to Assembly language programming"
	new_len equ $-new
	msg_len equ $- msg

	%macro print 2
		mov rax, 1
		mov rdi, 1
		mov rsi, %1
		mov rdx, %2
		syscall
	%endmacro
	%macro exit 0
		mov rax, 60
		mov rdi, 00
		syscall
	%endmacro
;------------------------------------------------------------------------------------------------------------------------------------------
section .text
	global _start
	_start:
		print msg, msg_len
		; print new, new_len
		exit


