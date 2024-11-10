;Kunal Shitole
;123B1B136
;Assignment 3
;-------------------------------------------------------------------------------------------------------------

section .data
    hmsg        db      10,"Enter 4 digit HEX Number::"
    hmsg_len    equ     $-hmsg
    ebmsg       db      10,"The Equivalent BCD Number is::"
    ebmsg_len   equ     $-ebmsg
    ermsg       db      10,"INVALID NUMBER INPUT",10
    ermsg_len   equ     $-ermsg

;----------------------------------------------------------------------------------------------------------------------
section .bss
    buf         resb    5
    char_ans    resb    1

%macro exit 0
    mov rax, 60                 ;60 means exit program with zero errors
    mov rdi, 0
    syscall                     ;when syscall is made stuff in ax and di is checked to determine what to do
%endmacro

%macro print 2
    mov rax, 1                  ;1 means print to terminal
    mov rdi, 1
    mov rsi, %1                 ;% is used to access arguments passed
    mov rdx, %2                 ;%1 is 1st arg and %2 is 2nd
    syscall
%endmacro

%macro read 2
    mov rax, 0                  ;syscall 0 means read: enterd string will be stored in rax
    mov rdi, 0  
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
;----------------------------
section .text

global _start
_start:
    call HEX_BCD

HEX_BCD:
    print   hmsg,hmsg_len
    call    Accept_16           ;Accepts 4 digot Hex number
    mov     ax, bx

    mov     bx, 10              ;Divide hex number by 10
    xor     bp, bp              ;Counter

    back:
    xor     dx, dx              ;dx contains remainder everytime
    div     bx                  ;divide ax by 10 ax=0,dx=R
    push    dx                  ;push dx on stack as it has bcd
    inc     bp                  ;increment by one

    cmp     ax,0                ;random bs idk
    jne     back

    print   ebmsg,ebmsg_len

    back1:
    pop     dx
    add     dl,30h
    mov     [char_ans], dl      ;Print individual digit
    print   char_ans, 1
    dec     bp
    jnz     back1               ;Moves to next digit

    ret
;------------------------------------------------------------------------------------------------------
Accept_16:                      ;ASCII(char) to hex number
input:
    read    buf,5               
    mov     rcx,4
    mov     rsi,buf             ;store base address into RSI
    xor     bx,bx               ;Checking bx is not 0

next_byte:
    shl     bx,4
    mov     al,[rsi]

    cmp     al,'0'
    jb      error
    cmp     al,'9'
    jbe     sub30

    cmp     al,'A'
    jb      error
    cmp     al,'F'
    jbe     sub37thirtthirt

    cmp     al,'a'
    jb      error
    cmp     al,'f'
    jbe     sub57

    error:
    print   ermsg,ermsg_len
    exit

    sub57:
    sub     al,20h
    sub37:
    sub     al,07h
    sub30:
    sub     al,30h
    add     bx,ax
    inc     rsi
    dec     rcx
    jnz     next_byte
    ret
    

