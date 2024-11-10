section .data
msg db "Hello world", 10
new db "Welcome to Assembly language programming"
new_len equ $-new
msg_len equ $-msg
section .text
global _start
_start:
; Print "Hello world"
mov rax, 1 ; System call for write
mov rdi, 1 ; File descriptor 1 (stdout)
mov rsi, msg ; Address of string to print
mov rdx, msg_len ; Length of string
syscall ; Make system call
; Uncomment this section to print "Welcome to Assembly language programming"
; mov rax, 1 ; System call for write
; mov rdi, 1 ; File descriptor 1 (stdout)
; mov rsi, new ; Address of second string to print
; mov rdx, new_len ; Length of second string
; syscall ; Make system call
; Exit the program
mov rax, 60 ; System call for exit
mov rdi, 0 ; Exit code 0
syscall ; Make system call

