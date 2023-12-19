include 'emu8086.inc'

    
ORG    100h

   
    call scan_num 
    mov n,cx 
    mov bx,n
    call fact  
    mov n_high,dx
    mov n_low,ax   
    call scan_num   
    mov m,cx
    mov bx,m
    call fact
    mov m_high,dx
    mov m_low,ax
    mov bx,n
    add bx,m
    call fact
    mov sum_high,dx
    mov sum_low,ax
    mov bx,n_low
    div bx
    mov bx,m_low
    div bx
    call print_num_uns  
        
    RET  
    
    n dw 0
    m dw 0
    n_high dw 0
    n_low dw 0
    m_high dw 0
    m_low dw 0
    sum_high dw 0
    sum_low dw 0
      

    fact proc 
        push bx
        cmp bx, 0
        je end_fact
        dec bx
        call fact
        inc bx       
        mul bx
        jmp fact_ret
        end_fact:
            mov ax, 1
        fact_ret:    
            pop bx
            ret
    endp      
                
    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS 
    
    END