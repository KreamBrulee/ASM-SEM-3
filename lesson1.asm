section .data
    msg db "hello world",0Ah
    msg_len equ $-msg

section .text
    gloabal _start
    
    _start:
        mov rax,0
        mov rdi,0
        mov rsi,msg
        mov rdx,msg_len
        syscall