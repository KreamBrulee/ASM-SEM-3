section .data
    nline db    10,10
    nline_len   equ     $-nline
    
    colon db    ":"
    colon_len   equ $-colon

    rmsg    db  10,"Processor is in Real Mode..."
    rmsg_len    equ $-rmsg

    pmsg    db  10,"Processor is in Protected Mode..."
    pmsg_len    equ $-pmsg

    gmsg    db  10,"GDTR : "
    gmsg_len    equ     $-gmsg

    imsg    db  10,"IDTR : "
    imsg_len    equ     $-imsg

    lmsg    db  10,"LDTR : "
    lmsg_len    equ     $-lmsg

    tmsg    db  10,"TR : "
    tmsg_len    equ     $-tmsg

    mmsg    db  10,"MSW : "
    mmsg_len    equ     $-mmsg 

;------------------------------------------------------------------------------------------------------------------------

section .bss
    GDTR    resw    3   ;48 bits = 3 words
    IDTR    resw    3
    LDTR    resw    1
    TR      resw    1
    MSW     resw    1

    char_ans resb   4

;------------------------------------------------------------------------------------------------------------
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

;------------------------------------------------------------------------------------------------------------------

section .text
global _start

_start:
    SMSW    [MSW]

    mov     rax,[MSW]
    ror     rax,1       ;Check PE bit,1:protected/0:Real

    jc      p_mode

    print   rmsg,rmsg_len
    jmp     next

p_mode:
    print   pmsg,pmsg_len
next:
    SGDT    [GDTR]
    SIDT    [IDTR]
    SLDT    [LDTR]
    STR     [TR]
    SMSW    [MSW]

    print   gmsg,gmsg_len
    mov     ax,[GDTR+4]
    call    disp16_proc

    mov     ax,[GDTR+2]
    call    disp16_proc
    print   colon,colon_len
    
    mov     ax,[GDTR+0]
    call    disp16_proc
    

    print imsg,imsg_len
    mov     ax,[IDTR+4]
    call    disp16_proc

    mov     ax,[IDTR+2]
    call    disp16_proc
    print   colon,colon_len
    
    mov     ax,[IDTR+0]
    call    disp16_proc


    print   lmsg,lmsg_len
    mov     ax,[LDTR]
    call    disp16_proc

    print   tmsg,tmsg_len
    mov     ax,[TR]
    call    disp16_proc

    print   mmsg,mmsg_len
    mov     ax,[MSW]
    call    disp16_proc

    print nline,nline_len
    exit

disp16_proc:
    mov     rbx,16
    mov     rcx,4
    mov     RSI,char_ans+3

cnt:
    mov     rdx,0
    div     rbx

    cmp     dl,09H

    jbe     add30
    add     dl,07H

add30:
    add     dl,30H
    mov     [rsi],dl

    dec     rsi
    dec     rcx

    jnz     cnt

    print   char_ans,4

ret
