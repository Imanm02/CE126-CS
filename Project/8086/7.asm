include 'emu8086.inc'

ORG 100h 
 
    lea    si,msg1
    call   print_string
    lea    di,strA
    mov    dx,buffsize
    call   get_string
    LEA    si, newln
    call   print_string 
    lea    si,msg2
    call   print_string
    lea    di,strB
    mov    dx,buffsize
    call   get_string
    LEA    si, newln
    call   print_string 
    lea    si,msg3
    call   print_string
    lea    di,strX
    mov    dx,buffsize
    call   get_string
    LEA    si, newln
    call   print_string 
    call   countReplace 
    mov    ax,num
    call   print_num_uns
    cmp    num, 0
    jz     done 
    LEA    si, newln
    call   print_string  
    lea    si,strNew
    call   print_string
    done:   RET
                      
    ;data
    msg1    db   "Enter string a : ",0
    msg2    db   "Enter string b : ",0
    msg3    db   "Enter string x : ",0   
    strA    db   100 dup(0)
    strB    db   100 dup(0)
    strX    db   100 dup(0)  
    strNew  db   100 dup(0) 
    last    dw   ?
    num     dw   0
    newln   db   13, 10, 0
    buffsize = $-buffer
   
    ;proc
    countReplace proc  
           lea     di,strA
           lea     si,strX
           lea     bx,strB
           lea     bp,strNew  
           mov     last,si  
           mov     ah,0
       loop1:  
           cmp     [di], ah
           jz      found              
           cmp     [si],ah
           jz      finished
           mov     ch,[di]
           cmp     [si],ch
           jz      continue 
           sub     ch, 20h
           cmp     [si],ch
           jz      continue
           add     ch,40h
           cmp     [si],ch
           jnz     notMatched
       continue:
           inc     di
           inc     si
           jmp     loop1 
       found:
           inc     num
           lea     di,strA 
           lea     bx,strB
           mov     last,si
       loop2:  
           cmp     [bx], ah 
           jz      loop1 
           mov     ch, [bx]
           mov     [bp],ch
           inc     bx   
           inc     bp
           jmp     loop2
       notMatched: 
           lea     di,strA
           mov     si,last   
           mov     ch,[si]
           mov     [bp],ch
           inc     bp
           inc     si
           mov     last,si  
           jmp     loop1
       finished:
           ret
   endp
                       
                      
   DEFINE_PRINT_STRING 
   DEFINE_PRINT_NUM
   DEFINE_PRINT_NUM_UNS                
   DEFINE_GET_STRING
END