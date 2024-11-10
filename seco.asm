section .data
    newline db "",10
    new_len db $- newline

    msg         db      10,10,"Enter the string: "
    msg_len     equ     $-msg

    smsg        db      10,10,"Length of string: "
    smsg_len    equ     $-smsg

;-----------------------------------------------------------------------------------------------------

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall                     ;when syscall is made stuff in ax and di is checked to determine what to do
%endmacro

%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1                  ;% is used to access arguments passed
    mov rdx, %2                              ;%1 is 1st arg and %2 is 2nd
    syscall
%endmacro

%macro read 2
    mov rax, 0                              ;syscall 0 means read: enterd string will be stored in rax
    mov rdi, 0  
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

;------------------------------------------------------------------------------------------------

section .bss
    string      resb    50                  ;Reserved strin to accept strin during runtime
    stringl     equ     $-string            

    char_ans    resb    2

    count       resb    1           ;will be sued to temporarily store the string

;---------------------------------------------------------------------------------------------------

section .text
    global _start

_start:
    print   msg,        msg_len

    read    string,     stringl
    mov     [count],    rax

    print   smsg,       smsg_len
    mov     rax,        [count]
    dec     rax

    call display    

    exit

display:
    mov rbx, 16                 
    mov rcx, 2
    mov rsi, char_ans+1

back:
    mov rdx, 0
    
    div rbx                     ;rax = rax/rbx

    cmp dl, 09h
    jbe add30                   ;jbe: Jump if Below or equal
    add dl, 07h

    add30:                      ;lable to add 30
        add dl, 30h

    mov [rsi], dl
    dec rsi
    dec rcx
    jnz back                    ;jnz; Jump if Not Zero


 
    print char_ans,2
    ret