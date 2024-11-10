; Assignment 4

section .data
    hmsg db 10,"Enter 4 digit Hex Numebr: "
    hmsg_len equ $-hmsg
    ebmsg db 10,"The equivalent BCD number is: "
    ebmsg_len equ $-ebmsg
    ermsg db 10,"INVALID NUMBER INPUT",10
    ermsg_len equ $-ermsg

section .bss
    buf resb 5
    char_ans resb 1


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
call HEX_BCD    

HEX_BCD:
    print hmsg, hmsg_len
    call Accept_16
    mov ax,bx

    mov bx,10
    xor bp,bp

back:
    xor dx,dx

    div bx
    push dx
    inc bp

    cmp ax,0
    jne back

    print ebmsg, ebmsg_len

back1:
    pop dx
    add dl,30h

    mov [char_ans],dl
    print char_ans, 1

    dec bp
    jnz back1
ret

Accept_16:
    read buf, 5

    mov rcx,4
    mov rsi, buf
    xor bx,bx

next_byte:
    shl bx,4
    mov al,[rsi]

    cmp al, '0'
    jb error
    cmp al,'9'
    jbe sub30

    cmp al,'A'
    jb error
    cmp al,'F'
    jbe sub37

    cmp al,'a'
    jb error
    cmp al,'f'
    jbe sub57

error:
    print ermsg, ermsg_len
    exit

sub57: SUB al,20H
sub37: SUB al,07H

sub30: SUB al,30H
       
       ADD bx,ax
       inc rsi
       dec rcx
       jnz next_byte

ret