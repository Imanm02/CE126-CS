;8086 program to print a 16 bit decimal number
.MODEL SMALL
.STACK 1000h
.DATA    
trash dw ?
num1 dw 132
.CODE

start:  MOV AX,@DATA
  MOV DS,AX 
  
  push offset num1
  
  CALL JOSEPHUS 
  
  mov ax,num1       
    
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
JOSEPHUS PROC
    push bp
    push dx
    push ax
    push si
    push di
    mov bp,sp
    mov si,word ptr[bp + 12]
    mov di,word ptr[si]
    cmp di,1
    jnz recrusive 
    pop di
    pop si
    pop ax
    pop dx
    pop bp 
    ret
recrusive:
    dec word ptr[si]
    push si
    CALL JOSEPHUS
    mov ax,word ptr [si]
    inc ax
    cwd
    div di
    inc dx
    mov word ptr[si],dx 
    pop trash       
    pop di
    pop si
    pop ax
    pop dx
    pop bp
    ret  
      
JOSEPHUS ENDP   
END start