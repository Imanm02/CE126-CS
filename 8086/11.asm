;8086 program to print a 16 bit decimal number
.MODEL SMALL
.STACK 1000h
.DATA
trash dw ?
isMirror dw ?
maxlen dw 0
startpoint dw -1 
strlen dw 10
str: db 'xaaasosaaa'
.CODE

start:
    MOV AX,@DATA
    MOV DS,AX
  
    mov cx,strlen
    dec cx
lop1:
    mov ax,cx
lop2:
    add ax,-1   
    ;todo
    mov dx,cx
    sub dx,ax
    add dx,1
    
    push offset isMirror
    push dx
    mov si,offset str
    add si,cx
    push si 
    mov si,offset str
    add si,ax
    push si 
    
    call mirror
    
    pop trash
    pop trash
    pop trash
    pop trash
    
    cmp isMirror,0
    jz notmatch
    cmp dx,maxlen
    jbe notmatch
    mov maxlen,dx
    mov startpoint,ax
notmatch:    
    cmp ax,0
    jnz lop2
    loop lop1
     
  
    mov ax,startpoint 
    
  CALL PRINT
          
  ;interrupt to exit      
  MOV AH,4CH
  INT 21H


PRINT PROC    
  
  ;initialize count
  mov cx,0
  mov dx,0
  label1:
    ; if ax is zero
    cmp ax,0
    je print1  
    
    ;initialize bx to 10
    mov bx,10  
    
    ; extract the last digit
    div bx        
    
    ;push it in the stack
    push dx      
    
    ;increment the count
    inc cx      
    
    ;set dx to 0
    xor dx,dx
    jmp label1
  print1:
    ;check if count
    ;is greater than zero
    cmp cx,0
    je exit
    
    ;pop the top of stack
    pop dx
    
    ;add 48 so that it
    ;represents the ASCII
    ;value of digits
    add dx,48
    
    ;interrupt to print a
    ;character
    mov ah,02h
    int 21h
    
    ;decrease the count
    dec cx
    jmp print1
exit:
ret
PRINT ENDP
  
mirror PROC
    push bp
    push cx
    push dx
    push ax
    push si
    push di
    mov bp,sp 
    mov si,word ptr[bp+14] ;start
    mov di,word ptr[bp+16] ;end
    mov cx,word ptr[bp+18] ;len 
    mov ax,0
    ;isMirror offset
lop:
    cld
    lodsb
    mov dl,byte ptr[di]
    dec di
    cmp ax,dx
    jnz notequal
    loop lop
    mov si,word ptr[bp+20]
    mov word ptr[si],1   
    pop di
    pop si
    pop ax
    pop dx
    pop cx
    pop bp
    ret  
notequal:
    mov si,word ptr[bp+20]
    mov word ptr[si],0
    pop di
    pop si
    pop ax
    pop dx
    pop cx
    pop bp
    ret
mirror ENDP
   
END start