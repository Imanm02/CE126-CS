include 'emu8086.inc'

stackseg segment STACK 'STACK'
  db 100 dup(?)
stackseg ends

dataseg segment
  n db 0
  ten db 10
  tempax dw 0
  tempbx dw 0
  tempcx dw 0
  tempdx dw 0
  i dw 0
  ma dw 0
  mb dw 0
  mc dw 0
  sa dw 0
  sb dw 0
  sc dw 0
  sd dw 0
  se dw 0
  sf dw 0
  t1 dw 0
  t2 dw 0
  t3 dw 0
  t4 dw 0
  norm1 dw 0
  norm2 dw 0
  t14 dw 0
  t24 dw 0
  t23a dw 0
  ffb dw 0
  ffc dw 0
  ansn dw 0
  ansd dw 0
  resfn dw 0
  resfd dw 0
  resdfn dw 0
  resdfd dw 0
  fx dw 20 dup(0)
  dfx dw 20 dup(0)
  
  
dataseg ends  

codeseg segment
    
assume ss:stackseg, cs:codeseg, ds:dataseg

start:
mov ax, dataseg
mov ds, ax
 
;mov norm1,300
;mov norm2,-80
;call normalize
;mov ax,norm2
;call print_num
;jmp end_program

call pthis
db 'input degree: ',0
call scan_num
inc cl
mov n,cl
call print_new_line

mov bx,0
mov dx,0
input_poly:
  call pthis
  db 'input a',0
  mov ax,dx
  call print_num
  call pthis
  db ': ',0
  call scan_num
  call print_new_line
  
  mov fx[bx],cx
  add bx,2
  inc dx
  mov ch,0
  mov cl,n
  cmp dx,cx
  jnz input_poly

mov bx,2
mov cx,1
calc_derivative:
  mov ax,fx[bx]
  mul cx
  mov dfx[bx-2],ax
  add bx,2 
  inc cx
  mov ah,0
  mov al,n
  cmp cx,ax
  jnz calc_derivative
 
mov i,2
mov ansn,1
mov ansd,1
newton_loop:
  mov bx,ansn
  mov cx,ansd
  call calc_fx
  mov resfn,bx
  mov resfd,cx
  
  ;mov ax,bx
  ;call print_num
  ;call pthis
  ;db 'ff',0
  ;mov ax,cx
  ;call print_num
  ;call pthis
  ;db 'ff',0
  
  mov bx,ansn
  mov cx,ansd
  call calc_dfx
  mov resdfn,bx
  mov resdfd,cx
  
  mov ax,resfn
  mov ma,ax
  mov ax,resdfd
  mov mb,ax
  call multiply
  mov ax,mc
  mov resfn,ax
  
  mov ax,resfd
  mov ma,ax
  mov ax,resdfn
  mov mb,ax
  call multiply
  mov ax,mc
  mov resfd,ax
  
  neg resfn
  
  mov ax,ansn
  mov sa,ax
  mov ax,ansd
  mov sb,ax
  mov ax,resfn
  mov sc,ax
  mov ax,resfd
  mov sd,ax
  
  call add_frac
  
  mov ax,se
  mov ansn,ax
  mov ax,sf
  mov ansd,ax 
  
  
  ;mov bx,ansn
  ;mov cx,ansd
  ;call print_float
  ;call print_new_line
  ;mov ax,ansd
  ;call print_num
  ;call print_new_line
  
  add i,-1
  cmp i,0
  jnz newton_loop  

mov bx,ansn
mov cx,ansd
call print_float
call print_new_line


end_program:
  mov ah,4CH  ; DOS: terminate program
  mov al,0    ; return code will be 0
  int 21H     ; terminate the program 

calc_fx proc ; bx is numerator and cx is denominator the result of f(bx/cx) goes to (bx/cx)
  mov ffb,bx
  mov ffc,cx
  mov ax,0
  mov dx,1
  mov t1,ax
  mov t2,dx
  mov t3,dx
  mov t4,dx
  mov di,0
  mov cx,0
  calc_fx_lop:
    mov ax,t1
    mov ma,ax
    mov ax,t4
    mov mb,ax
    call multiply
    mov ax,mc
    mov t14,ax
    
    mov ax,t2
    mov ma,ax
    mov ax,t4
    mov mb,ax
    call multiply
    mov ax,mc
    mov t24,ax
    
    mov ax,t2
    mov ma,ax
    mov ax,t3
    mov mb,ax
    call multiply
    mov ax,mc
    mov ma,ax
    mov ax,fx[di]
    mov mb,ax
    call multiply
    mov ax,mc
    
    add ax,t14
    mov norm1,ax
    mov ax,t24
    mov norm2,ax
    call normalize
    mov ax,norm1
    mov t1,ax
    mov ax,norm2
    mov t2,ax
    
    add di,2
    inc cx
    
    mov ax,t3
    mov ma,ax
    mov ax,ffb
    mov mb,ax
    call multiply
    mov ax,mc
    mov norm1,ax
    
    mov ax,t4
    mov ma,ax
    mov ax,ffc
    mov mb,ax
    call multiply
    mov ax,mc
    mov norm2,ax
    
    call normalize
    mov ax,norm1
    mov t3,ax
    mov ax,norm2
    mov t4,ax
    
    cmp cl,n
    jnz calc_fx_lop
  mov bx,t1
  mov cx,t2   
  ret
calc_fx endp


calc_dfx proc ; bx is numerator and cx is denominator the result of f(bx/cx) goes to (bx/cx)
  mov ffb,bx
  mov ffc,cx
  mov ax,0
  mov dx,1
  mov t1,ax
  mov t2,dx
  mov t3,dx
  mov t4,dx
  mov di,0
  mov cx,0
  calc_dfx_lop:
    mov ax,t1
    mov ma,ax
    mov ax,t4
    mov mb,ax
    call multiply
    mov ax,mc
    mov t14,ax
    
    mov ax,t2
    mov ma,ax
    mov ax,t4
    mov mb,ax
    call multiply
    mov ax,mc
    mov t24,ax
    
    mov ax,t2
    mov ma,ax
    mov ax,t3
    mov mb,ax
    call multiply
    mov ax,mc
    mov ma,ax
    mov ax,dfx[di]
    mov mb,ax
    call multiply
    mov ax,mc
    
    add ax,t14
    mov norm1,ax
    mov ax,t24
    mov norm2,ax
    call normalize
    mov ax,norm1
    mov t1,ax
    mov ax,norm2
    mov t2,ax
    
    add di,2
    inc cx
    
    mov ax,t3
    mov ma,ax
    mov ax,ffb
    mov mb,ax
    call multiply
    mov ax,mc
    mov norm1,ax
    
    mov ax,t4
    mov ma,ax
    mov ax,ffc
    mov mb,ax
    call multiply
    mov ax,mc
    mov norm2,ax
    
    call normalize
    mov ax,norm1
    mov t3,ax
    mov ax,norm2
    mov t4,ax
    
    cmp cl,n
    jnz calc_dfx_lop
  mov bx,t1
  mov cx,t2   
  ret
calc_dfx endp   
 
 
add_frac proc; multiply (sa/sb) and (sc/sd) and put result in se/sf
  call save_registers
  mov ax,sa
  mov ma,ax
  mov ax,sd
  mov mb,ax
  call multiply
  mov ax,mc
  mov norm1,ax
  
  mov ax,sb
  mov ma,ax
  mov ax,sc
  mov mb,ax
  call multiply
  mov ax,mc
  add norm1,ax
  
  mov ax,sb
  mov ma,ax
  mov ax,sd
  mov mb,ax
  call multiply
  mov ax,mc
  mov norm2,ax
  
  call normalize
  mov ax,norm1
  mov se,ax
  mov ax,norm2
  mov sf,ax 
  
  call retrieve_registers   
  ret
add_frac endp   
    
  


print_float proc; bx is numerator and cx is denominator the result of bx/cx is printed as a result
  call save_registers
  cmp cx,0
  jz no_solution
  jg dont_neg_bx
  neg bx
  neg cx
  dont_neg_bx:
  cmp bx,0
  jge dont_print_minus
  call pthis
  db '-',0
  neg bx
  dont_print_minus:
  mov ax,bx
  mov dx,0
  div cx
  call print_num
  call pthis
  db '.',0
  mov bx,6
  print_float_lop:
    mov ax,dx
    mul ten
    mov dx,0
    div cx
    call print_num
    dec bx
    cmp bx,0
    jnz print_float_lop
  call retrieve_registers
  ret
print_float endp

save_registers proc
  mov tempax,ax
  mov tempbx,bx
  mov tempcx,cx
  mov tempdx,dx
  ret
save_registers endp

retrieve_registers proc
  mov ax,tempax
  mov bx,tempbx
  mov cx,tempcx
  mov dx,tempdx
  ret
retrieve_registers endp

print_new_line proc
  call pthis
  db 13,10,0
  ret
print_new_line endp 

multiply proc; multiply ma and mb and put result in mc
  call save_registers
  mov dx,0
  mov ax,ma
  mul mb
  mov mc,ax
  call retrieve_registers
  ret
multiply endp

normalize proc; normalize norm1/norm2
  call save_registers
  mov ax,norm1
  mov bx,norm2
  norm_loop1:
    cmp ax,128
    jl norm_pass1
    sar ax,1
    sar bx,1
    jmp norm_loop1
  norm_pass1:
  
  norm_loop2:
    cmp bx,128
    jl norm_pass2
    sar ax,1
    sar bx,1
    jmp norm_loop2
  norm_pass2:
  neg ax
  neg bx
  norm_loop3:
    cmp ax,128
    jl norm_pass3
    sar ax,1
    sar bx,1
    jmp norm_loop3
  norm_pass3:
  
  norm_loop4:
    cmp bx,128
    jl norm_pass4
    sar ax,1
    sar bx,1
    jmp norm_loop4
  norm_pass4:
  neg ax
  neg bx
  mov norm1,ax
  mov norm2,bx
  call retrieve_registers 
  ret
normalize endp
    
no_solution:
  call pthis
  db 'no solution exists',13,10,0
  call end_program


DEFINE_SCAN_NUM; get number in cx
DEFINE_PRINT_NUM; print number in ax
DEFINE_PRINT_NUM_UNS
DEFINE_PRINT_STRING;address in si
DEFINE_GET_STRING;address in di , size dx
DEFINE_PTHIS; call pthis; db 13,10,0

codeseg ends
end start