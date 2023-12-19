include 'emu8086.inc'

    
ORG    100h

    call scan_num  
    mov x , cx
    call scan_num  
    mov y , cx
    call scan_num  
    mov xp , cx
    call scan_num  
    mov yp , cx
    mov ax , x
    mov bx , x
    imul bx
    mov s_low , ax
    mov s_high , dx
    mov ax , y
    mov bx , y
    imul bx
    add s_low , ax
    add s_high , dx
    mov ax , xp
    mov bx , xp
    imul bx
    mov m_low , ax
    mov m_high , dx
    mov ax , yp
    mov bx , yp
    imul bx
    add m_low , ax
    add m_high , dx
    mov ax , s_low
    mov dx , s_high
    mov bx , m_low
    idiv bx
    call sqrt
    mov z , cx
    mov ax , x
    mov bx , yp
    imul bx
    mov s_low , ax
    mov s_high , dx
    mov ax , y
    mov bx , xp
    imul bx
    sub s_low , ax
    sub s_high , dx
    mov ax , x
    mov bx , xp
    imul bx
    mov m_low , ax
    mov m_high , dx
    mov ax , y
    mov bx , yp
    imul bx
    add m_low , ax
    add m_high , dx
    mov dx , s_high
    mov ax , s_low
    mov bx , m_low
    idiv bx
    call arctg
    mov r , bx    
    ; z and r are ready to print!
;    call print_num_uns    
   
           
    RET
    x dw 0
    y dw 0
    xp dw 0
    yp dw 0 
    z dw 0
    r dw 0
    s_low dw 0
    s_high dw 0
    m_low dw 0
    m_high dw 0

                    
    sqrt proc          
        mov cx , 0000
        mov bx , -1
        lable:
            add bx , 02
            inc cx
            sub ax , bx
            jnz lable
            ret
    endp
                         
                    
    arctg proc 
        push ax
        mov cx , 10
        mov bx , 0
        mov si , 3
        mov di , -1
        imul ax
        imul di
        mov di , ax
        pop ax
        loop_lable:
            push ax
            imul di
            idiv si
            add bx , ax
            imul si 
            add si , 2
            loop loop_lable
        ret
   
    endp
                      
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS  ; required for print_num.
    
    END