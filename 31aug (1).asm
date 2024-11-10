; Assignment 2 --> Write x86/64 ALP to accept a string and display its length

section .data
    msg db 10,10,"Enter a string: "
    msg_len equ $-msg

    smsg db 10,10,"The length of the string is: "
    smsg_len equ $-smsg

    new_line db "",10
    new_line_len equ $-new_line

section .bss
    string resb 50
    stringl equ $-string
    count resb 1
    char_ans resb 2

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
    print msg, msg_len
    read string, stringl
    mov [count], rax

    print smsg, smsg_len
    mov rax, [count]
    dec rax
    call Display
    exit

Display:
    mov rbx, 16
    mov rcx, 2
    mov rsi, char_ans+1

back:
    mov rdx, 0

    div rbx

    cmp dl, 09h
    jbe add30
    add dl, 07h

    add30:
    add dl, 30h

    mov [rsi], dl
    dec rsi
    dec rcx
    jnz back

    print char_ans, 2
    print new_line,new_line_len
    ret