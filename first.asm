%define ENDL 0x0D, 0x0A	;macro defined to notalways always

section .data
newline db "",10
new_len db $- newline

%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall                     ;when syscall is made stuff in ax and di is checked to determine what to do
%endmacro

%macro print 2
    mov ax, 0
    mov di, 1
    mov si, %1                  ;% is used to access arguments passed
    mov rdx, %2                              ;%1 is 1st arg and %2 is 2nd
    syscall
%endmacro


section .bss
    char_ans resb 2             ;In bss varibles are declaed that will recive value at run time
                                ;rest stands for reserve bytes
                                ;To print any Integer value do (val +30h) ex:0->30,5
                                ; 


section .text
    global _start

_start:
    mov rax, 20
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
    print newline, new_len
    ret