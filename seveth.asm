; Assignment name: Block transfer-overlapped with string instruction
section .data
    nline db 10,10
    nline_len equ $-nline

    space db " "

    ano db 10,"    Assingment no. 7",
        db 10, "------------------------------------------------------------------------------------"
        db 10, "    Block Transfer-Overlapped with String Instruction "
        db 10,"-------------------------------------------------------------------------------------",10
    
    ano_len equ $-ano

    bmsg db 10,"Before Transfer:     "
    bmsg_len equ $-bmsg

    amsg db 10,"After Transfer:      "
    amsg_len equ $-amsg

    smsg db 10,"Source Block:        "
    smsg_len equ $-smsg

    dmsg db 10,"Destination Block:   "
    dmsg_len equ $-dmsg

    sblock db 36H,42H,8H,11H,2H ;define array of integers
    dblock times 5 db 0 ; define array of size 5 with all values 0

;----------------------------------------------------------------------------------------------------------------

section .bss
        char_ans resB 2

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

;-----------------------------------------------------------------------------------------------------------------


section .text
    global _start

_start:
    print ano,ano_len

    print bmsg,bmsg_len

    print smsg,smsg_len

    mov rsi,sblock

    call disp_block

    print dmsg,dmsg_len
    mov rsi,dblock-3
    call disp_block

    call BT_OS

    print amsg, amsg_len

    print smsg, smsg_len
    mov rsi , sblock
    call disp_block

    print dmsg, dmsg_len
    mov rsi,dblock-2
    call disp_block

    print nline,nline_len

exit

;---------------------------------------------------------------------------------------------------------------

BT_OS:
    mov rsi,sblock+4
    mov rdi, dblock+2
    mov rcx,5

    std

    rep movsb
ret

;----------------------------------------------------------------------------------------------------------------

disp_block:
    mov rbp,5 

next_num:
    mov al, [rsi]
    push rsi

    call Disp_8
    print space, 1

    pop rsi
    inc rsi

    dec rbp
    jnz next_num
ret

Disp_8:
    mov rsi, char_ans+1
    mov rcx,2
    mov rbx,16

next_digit:
    xor rdx,rdx
    div rbx

    cmp dl,9
    jbe add30
    add dl,07H

add30:
    add dl,30H
    mov [rsi],dl

    dec rsi
    dec rcx
    jnz next_digit

    print char_ans,2
ret


