; Assignment 3

section .data
    nline db 10,10
    nline_len equ $-nline
    ano db 10,"Assignment no. : 3",10
        db "Postitive/Negative elements from 64-bit array",10
    ano_len equ $-ano
    arr64 dq 29H, -55FH, -2H, -62H, 99H
    n equ 5
    pmsg db 10,10,"The no. of positive elements form 64-bit array: "
    pmsg_len equ $-pmsg
    nmsg db 10,10,"The no. of negative elements from 64-bit array: "
    nmsg_len equ $-nmsg

section .bss
    p_count resq 1
    n_count resq 1
    char_ans resb 16


%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

section .text 
    global _start

_start:
    print ano, ano_len
    mov rsi, arr64
    mov rcx, n
    mov rbx, 0
    mov rdx, 0

next_num:
    mov rax, [rsi]
    Rol rax, 1
    jc negative

positive:
    inc rbx
    jmp next

negative:
    inc rdx

next:
    add rsi, 8
    dec rcx
    jnz next_num

    mov [p_count], rbx
    mov [n_count], rdx

    print pmsg, pmsg_len
    mov rax, [p_count]
    call disp64_proc

    print nmsg, nmsg_len
    mov rax, [n_count]
    call disp64_proc

    print nline, nline_len
    exit

    disp64_proc:
    mov rbx, 16
    mov rcx, 2
    mov rsi, char_ans+1

cnt:
    mov rdx, 0
    div rbx
    cmp dl, 09h

    jbe add30
    add dl,07h

    add30:
    add dl,30h
    mov [rsi], dl

    dec rsi
    dec rcx
    jnz cnt

    print char_ans, 2

ret
