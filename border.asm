;[org 0x100]

start:
    ; 1. Get dimensions from BDA
    mov ax, 0x40
    mov es, ax
    mov cl, [es:0x4A]   ; CL = Columns
    mov ch, [es:0x84]   ; CH = Rows - 1
    inc ch              ; CH = Total Rows

    ; 2. Point ES to Video Memory
    mov ax, 0xB800
    mov es, ax
    xor di, di          ; ES:DI = top left

    ; 3. Draw Loop
    xor bx, bx          ; BX = Current Row
row_loop:
    xor dx, dx          ; DX = Current Col
col_loop:
    mov al, ' '         ; Default background
    
    ; Edge detection
    test bx, bx         ; Top row (0)?
    jz draw_edge
    
    mov ah, ch
    dec ah
    cmp bl, ah          ; Bottom row?
    je draw_edge
    
    test dx, dx         ; Left col (0)?
    jz draw_edge
    
    mov ah, cl
    dec ah
    cmp dl, ah          ; Right col?
    je draw_edge
    jmp write_char

draw_edge:
    mov al, '#'         ; Border character

write_char:
    stosb               ; Store AL at ES:DI and inc DI
    mov al, 0x07        ; Light grey attribute
    stosb               ; Store AL at ES:DI and inc DI

    inc dx
    cmp dl, cl
    jb col_loop         ; unsigned compare for widths >= 128

    inc bx
    cmp bl, ch
    jb row_loop

    ; Wait for key before exit so you can see the result
    mov ah, 0x00
    int 0x16

    mov ax, 0x4C00
    int 0x21
