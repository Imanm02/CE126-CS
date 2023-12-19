;8086 program to print a 16 bit decimal number
.MODEL SMALL
.STACK 1000h
.DATA
trash dw ? 
a dw 4   
b dw 9
x dw 102
temp dw 0 
ten dw 10
.CODE

start:  MOV AX,@DATA
  MOV DS,AX
  
  push 10
  push offset temp
  push x
  push a
  
  call toTEN
  
  pop trash 
  pop trash 
  pop trash 
  pop trash 
  
  mov ax,temp
  mov x,ax
  mov temp,0
  
  push 10
  push offset temp
  push x
  push b
  
  call toX
   
  
  
  mov ax,temp
      
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
  
toTEN PROC
    push bp
    push cx
    push dx
    push bx
    push ax
    push si
    push di
    mov bp,sp 
    mov si,word ptr[bp+16] ;a
    mov bx,word ptr[bp+18] ;x
    mov di,word ptr[bp+20] ;temp offset
    mov cx,1
    cmp ax,0
    jz end 
lop: 
    mov ax,bx
    div word ptr[bp+22]
    mov bx,ax
    mov ax,dx
    mul cx
    add word ptr[di],ax
    mov ax,cx
    mul si
    mov cx,ax
    cmp bx,0
    jnz lop
end: 
    pop di
    pop si
    pop ax
    pop bx
    pop dx
    pop cx
    pop bp
    ret 
toTEN ENDP 

toX PROC
    push bp
    push cx
    push dx
    push bx
    push ax
    push si
    push di
    mov bp,sp 
    mov si,word ptr[bp+16] ;b
    mov bx,word ptr[bp+18] ;x
    mov di,word ptr[bp+20] ;temp offset
    mov cx,1
    cmp ax,0
    jz end2 
lop2: 
    mov ax,bx
    div si
    mov bx,ax
    mov ax,dx
    mul cx
    add word ptr[di],ax
    mov ax,cx
    mul word ptr[bp+22]
    mov cx,ax
    cmp bx,0
    jnz lop2
end2: 
    pop di
    pop si
    pop ax
    pop bx
    pop dx
    pop cx
    pop bp
    ret 
toX ENDP

   
END start