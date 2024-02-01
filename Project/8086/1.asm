include 'emu8086.inc'

    
ORG 100h
      
    call scan_num 
    mov ch, 0
    mov n, cl
     
    mov si, 0
    mov dh, 0
    mov dl, 0
    
GETROW:
    add dh, 2
    mov x, dl    
    mov y, dh
    GOTOXY x, y
    
    
    
    call scan_num
    mov ch, 0
    mov matrix[si], cl
    
    add si, 1         
    
    add dl, 2
    mov al, n
    mov cl, 2
    mul cl
    cmp dl, al
    jne NOTEQUALTON
    mov dl, 0
    add dh, 2

NOTEQUALTON:
    sub dh, 2
    cmp dh, al
    jne GETROW
    
    GAUSS                 
      
RET

n db ?
matrix db 100 dup(?)
inv_matrix db 100 dup(0)
x db 0
y db 0

PRINTMATRIX macro
    push si
    push di
    push ax
    push bx
    push cx
    push dx
    
    call CLEAR_SCREEN
    mov si, 0
    mov dh, 0
    mov dl, 0
    
PRINTROWX:
    mov x, dl
    mov y, dh
    GOTOXY x, y
    mov al, inv_matrix[si]
    cbw
    call print_num
    print '/'
    mov al, dh
    mul n
    add al, dh
    cbw
    mov di, ax
    mov al, matrix[di]
    cbw
    call print_num
    
    add si, 1
    
    add dl, 6
    mov ax, 0
    mov al, n
    mov cl, 6
    mul cl
    cmp dl, al
    jne NOTEQUALPRINTMATRIXX
    mov dl, 0
    add dh, 1
    
NOTEQUALPRINTMATRIXX:
    mov al, n
    cmp dh, al
    jne PRINTROWX
                
                
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop si
endm
    

PRINTMATRIXX macro
    push si
    push di
    push ax
    push bx
    push cx
    push dx
    
    call CLEAR_SCREEN
    mov si, 0
    mov dh, 0
    mov dl, 0
    
PRINTROW:
    mov x, dl
    mov y, dh
    GOTOXY x, y
    mov al, matrix[si]
    cbw
    call print_num
    
    add si, 1
    
    add dl, 2
    mov ax, 0
    mov al, n
    mov cl, 2
    mul cl
    cmp dl, al
    jne NOTEQUALPRINTMATRIX
    mov dl, 0
    add dh, 2
    
NOTEQUALPRINTMATRIX:
    mov al, n
    mov cl, 2
    mul cl
    cmp dh, al
    jne PRINTROW
                
                
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop si
endm    
    
    
GAUSS macro
    mov cl, 0
    INITIALIZE:
        mov ah, 0
        mov al, cl
        mul n   
        add al, cl
        mov si, ax ; si = i * n + i (inv_matrix[si] = inv_matrix[i][i])
        mov inv_matrix[si], 1
        inc cl
        cmp cl, n
        jl INITIALIZE
        
    MAINLOOP:
        mov j, 0
        FINDBESTLOOP:
            mov al, j
            mov cl, n
            mul cl ; ax = j * n
            add al, i
            mov si, ax ; si = j * n + i (matrix[si] = matrix[j][i]   
                      
            cmp matrix[si], 0
            je BADNOMINATE
        
            mov al, j
            mov bestj, al

            BADNOMINATE:
                add j, 1
                mov al, j
                cmp al, n
                jne FINDBESTLOOP
        
        ; bestj is the last row that matrix[bestj][i] != 0, so it should be greater than i
        mov al, bestj
        cmp al, i
        jl NoAnswer
        
        SWAPROWS i, bestj
        
        mov j, 0
        MAKEOTHERZEROLOOP:
            mov al, j
            cmp al, i
            je ITSZERONOW
            
            mov al, j
            mov cl, n
            mul cl ; ax = j * n
            add al, i
            mov si, ax ; si = j * n + i (matrix[si] = matrix[j][i]   
                      
            cmp matrix[si], 0
            je ITSZERONOW
            DECROW j, i
            
            ITSZERONOW:                          
                add j, 1
                mov al, j
                cmp al, n
                jne MAKEOTHERZEROLOOP
       
        
        mov al, i
        inc al
        mov i, al
        cmp al, n
        jl MAINLOOP
    
    PRINTMATRIX    
    
    RET
    
NoAnswer:
    call CLEAR_SCREEN
    print 'NO ANSWER'
    RET    
    
endm

nomatrix db 'NO ANSWER'


SWAPROWS macro i, j               
    push ax
    push cx
    push dx
    push si
    
    mov al, i
    cmp al, j
    je RETSWAPROWS
    
    mov cl, 0
    mov ax, 0
    
    LOOPSWAPROWS:
        mov al, i
        mov ah, 0
        mul n
        add al, cl
        mov si, ax
        xchg matrix[si], dl
        xchg inv_matrix[si], dh
        
        mov al, j
        mov ah, 0
        mul n
        add al, cl             
        mov si, ax
        xchg matrix[si], dl
        xchg inv_matrix[si], dh
        
        mov al, i
        mov ah, 0
        mul n
        add al, cl
        mov si, ax
        xchg matrix[si], dl
        xchg inv_matrix[si], dh
        
        inc cl  
        cmp cl, n
        jl LOOPSWAPROWS
        
    RETSWAPROWS:    
    
    pop si
    pop dx    
    pop cx
    pop ax
                   
endm                   
  
  
DECROW macro j, i               
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov al, i
    mov ah, 0
    mul n
    add al, i
    mov si, ax
    mov bl, matrix[si] ; bl = matrix[i][i]
    
    mov al, j
    mov ah, 0
    mul n
    add al, i
    mov si, ax
    mov bh, matrix[si] ; bh = matrix[j][i]

    
    mov cl, 0
    mov ax, 0
    
    LOOPDECROWS:
        mov al, i
        mov ah, 0
        mul n
        add al, cl
        mov si, ax
        mov dl, matrix[si] ; dl = matrix[i][cl]
        
        mov al, j
        mov ah, 0
        mul n
        add al, cl             
        mov si, ax
        mov dh, matrix[si] ; dh = matrix[j][cl]
        
        ; matrix[j][cl] should be matrix[j][cl] * matrix[i][i] (bl) - matrix[i][cl] * matrix[j][i] (bh)
        
        mov al, dh
        mul bl
        mov dh, al
        
        
        mov al, dl
        mul bh
        mov dl, al
        
        sub dh, dl
 
        mov matrix[si], dh
        
        ; duplicate code for doing samething on inv_matrix
        
        mov al, i
        mov ah, 0
        mul n
        add al, cl
        mov si, ax
        mov dl, inv_matrix[si] ; dl = matrix[i][cl]
        
        mov al, j
        mov ah, 0
        mul n
        add al, cl             
        mov si, ax
        mov dh, inv_matrix[si] ; dh = matrix[j][cl]
        
        ; matrix[j][cl] should be matrix[j][cl] * matrix[i][i] (bl) - matrix[i][cl] * matrix[j][i] (bh)
        
        mov al, dh
        mul bl
        mov dh, al
        
        
        mov al, dl
        mul bh
        mov dl, al
        
        sub dh, dl
        
        mov inv_matrix[si], dh         
        
        inc cl  
        cmp cl, n
        jl LOOPDECROWS
    
    pop si
    pop dx    
    pop cx
    pop bx
    pop ax
                   
endm   

i db 0
j db 0
bestj db 0

DEFINE_CLEAR_SCREEN                      
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
END   