; Simple NASM program to draw a rectangle and move it using arrow keys
; Run in DOSBox with the appropriate settings (VGA graphics mode)

section .data
    rect_width  db 20     ; Width of the rectangle
    rect_height db 10     ; Height of the rectangle
    color       db 7      ; White color (color attribute for VGA)

section .bss
    x_pos   resb 1        ; X position of the rectangle
    y_pos   resb 1        ; Y position of the rectangle
    keypress resb 1       ; Store key press

section .text
    global _start
    org 0x100            ; Set the start address for DOS .COM file

_start:
    ; Initialize video mode to 0x13 (320x200 256-color graphics mode)
    mov ah, 0x00         ; Function 0 (set video mode)
    mov al, 0x13         ; Mode 0x13 (320x200 256-color)
    int 0x10             ; BIOS interrupt to set video mode

    ; Initialize rectangle position
    mov byte [x_pos], 100    ; X position (in pixels)
    mov byte [y_pos], 100    ; Y position (in pixels)

    ; Main loop
main_loop:
    ; Draw the rectangle at the current position
    call DrawRectangle

    ; Wait for key press (arrow keys)
    call WaitForKeyPress

    ; Handle the arrow key input and update position
    call HandleArrowKey

    ; Loop
    jmp main_loop

; Draw the rectangle on the screen at (x, y)
DrawRectangle:
    ; Get the current position (x, y)
    movzx si, byte [x_pos]   ; X position
    movzx di, byte [y_pos]   ; Y position

    ; Loop over the rectangle area (width x height)
    movzx cx, byte [rect_width]
    movzx bx, byte [rect_height]
draw_loop_y:
    mov ax, si              ; X position (column)
    mov dx, di              ; Y position (row)

    ; Calculate the linear offset into video memory (320 * y + x)
    mov dx, 320
    mul dx                    ; ax = x * 320
    add ax, si                ; ax = (y * 320) + x

    ; Set the pixel color in VGA memory (starting from 0xA000 segment)
    mov ax, 0xA000          ; Set the VGA memory segment
    mov es, ax              ; Load it into es register

    mov di, ax              ; Set the destination index (pixel offset)
    mov al, [color]         ; Set the pixel color
    mov [es:di], al         ; Write the pixel to the screen

    ; Move to the next pixel in the row
    inc si
    dec cx
    jnz draw_loop_y

    ; Move to the next row
    inc di
    dec bx
    jnz draw_loop_y

    ret

; Wait for a key press (blocking, non-extended keys)
WaitForKeyPress:
    mov ah, 0x00             ; BIOS function to read a key press
    int 0x16                 ; Keyboard interrupt
    mov [keypress], al       ; Store key press
    ret

; Handle the arrow key input and update the rectangle's position
HandleArrowKey:
    mov al, [keypress]       ; Load the keypress directly into al
    cmp al, 0xE0             ; Check for extended key prefix (0xE0)
    jne check_key            ; If not, jump to normal key handling

    ; If extended key (0xE0), get the actual key code
    mov ah, 0x00             ; BIOS function to read the key
    int 0x16                 ; Read the extended key
    mov al, [keypress]       ; Get the actual extended key code
    cmp al, 0x48             ; Up arrow (0x48)
    je move_up
    cmp al, 0x50             ; Down arrow (0x50)
    je move_down
    cmp al, 0x4B             ; Left arrow (0x4B)
    je move_left
    cmp al, 0x4D             ; Right arrow (0x4D)
    je move_right
    ret

check_key:
    cmp al, 0x48             ; Up arrow (0x48)
    je move_up
    cmp al, 0x50             ; Down arrow (0x50)
    je move_down
    cmp al, 0x4B             ; Left arrow (0x4B)
    je move_left
    cmp al, 0x4D             ; Right arrow (0x4D)
    je move_right
    ret

move_up:
    dec byte [y_pos]         ; Move up (decrease y_pos)
    ret

move_down:
    inc byte [y_pos]         ; Move down (increase y_pos)
    ret

move_left:
    dec byte [x_pos]         ; Move left (decrease x_pos)
    ret

move_right:
    inc byte [x_pos]         ; Move right (increase x_pos)
    ret
