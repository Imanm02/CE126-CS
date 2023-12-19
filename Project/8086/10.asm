; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

include 'emu8086.inc'


stackseg segment STACK 'STACK'
    
stackseg ends



dataseg segment
    xs db 100 dup (?)
    ys db 100 dup (?)
    labels db 100 dup (?)
    n db ?
    best_err db 0
    best_ans db 0
    cur_ans db 0
    pivot db ?    
dataseg ends


codeseg segment
    assume cs: codeseg, ds: dataseg, ss: stackseg
    
start:
    mov ax, dataseg
    mov ds, ax
    
    call scan_num
    mov n, cl
    
    call pthis
    db 13, 10, 0
    
    push bx
    mov bx, 0
    call get_array
    pop bx
    
    
    push bx
    mov bl, n
    mov best_err, bl
    mov bx, 0
    call solve1
    pop bx
    
    

get_array:
    cmp bl, n
    jne get_num
    ret
     
get_num:
    call scan_num
    call pthis
    db 13, 10, 0
    mov  xs [bx], cl
    call scan_num
    call pthis
    db 13, 10, 0
    mov  ys [bx], cl
    call scan_num
    call pthis
    db 13, 10, 0
    mov  labels [bx], cl
    inc bx
    call get_array
    ret
    
    
solve1:
    cmp bl, n
    jne csolve1
    call pthis
    db 13, 10, 'the answer for first problem is: x=', 0
    push ax
    mov ah, 0
    mov al, best_ans 
    call print_num
    call pthis
    db 13,10,'error is:',0
    mov al, best_err
    call print_num
    pop ax
    mov bl, n
    mov best_err, bl ;resetting the answer to solve second problem
    mov bx, 0
    call solve2
    ret 
csolve1:
    push ax
    push cx
    mov cx, 0
    mov cur_ans, 0
    mov al, xs [bx]
loop1:
    cmp cl, n
    jne calc
    push bx
    mov bl, cur_ans
    cmp bl, best_err
    jl update
    pop bx
    pop cx
    pop ax
    inc bx
    call solve1
    ret
update:
    mov best_err, bl
    pop bx
    mov cl, xs [bx]
    mov best_ans, cl
    pop cx
    pop ax
    inc bx
    call solve1
    ret
    
calc:
    xchg cx, bx
    cmp al, xs [bx]
    jl case1
    cmp xs [bx], al
    jl case2
    xchg cx, bx
    inc cx
    call loop1
    ret
    
case1:
    push dx
    mov dl, labels [bx]
    cmp dl, 0
    je inc_ans
    xchg bx, cx
    pop dx
    inc cx
    call loop1
    ret
    
case2:
    push dx
    mov dl, labels [bx]
    cmp dl, 1
    je inc_ans
    xchg bx, cx
    pop dx
    inc cx
    call loop1
    ret
    

inc_ans:
    inc cur_ans
    pop dx
    xchg bx, cx
    inc cx
    call loop1
    ret


solve2:
    cmp bl, n
    jne csolve2
    call pthis
    db 13, 10, 'the answer for second problem is: y=', 0
    push ax
    mov ah, 0
    mov al, best_ans 
    call print_num
    call pthis
    db 13,10,'error is:',0
    mov al, best_err
    call print_num
    pop ax
    mov bl, n
    mov best_err, bl ;resetting the answer to solve second problem
    mov bx, 0
    call solve3
    ret 
csolve2:
    push ax
    push cx
    mov cx, 0
    mov cur_ans, 0
    mov al, ys [bx]
loop2:
    cmp cl, n
    jne calc2
    push bx
    mov bl, cur_ans
    cmp bl, best_err
    jl update2
    pop bx
    pop cx
    pop ax
    inc bx
    call solve2
    ret
update2:
    mov best_err, bl
    pop bx
    mov cl, ys [bx]
    mov best_ans, cl
    pop cx
    pop ax
    inc bx
    call solve2
    ret
    
calc2:
    xchg cx, bx
    cmp al, ys [bx]
    jl case12
    cmp ys [bx], al
    jl case22
    xchg cx, bx
    inc cx
    call loop2
    ret
    
case12:
    push dx
    mov dl, labels [bx]
    cmp dl, 0
    je inc_ans2
    xchg bx, cx
    pop dx
    inc cx
    call loop2
    ret
    
case22:
    push dx
    mov dl, labels [bx]
    cmp dl, 1
    je inc_ans2
    xchg bx, cx
    pop dx
    inc cx
    call loop2
    ret
    

inc_ans2:
    inc cur_ans
    pop dx
    xchg bx, cx
    inc cx
    call loop2
    ret
    
solve3:
    cmp bl, 10
    jne csolve3
    call pthis
    db 13, 10, 'the answer for third problem is: y=', 0
    push ax
    mov ah, 0
    mov al, best_ans 
    call print_num
    call pthis
    db 'x',13,10,'error is:',0
    mov al, best_err
    call print_num
    pop ax
    mov AH,4cH
    mov AL, 0
    int 21H 
csolve3:
    push ax
    push cx
    mov cx, 0
    mov cur_ans, 0
loop3:
    cmp cl, n
    jne calc3
    push bx
    mov bl, cur_ans
    cmp bl, best_err
    jl update3
    pop bx
    pop cx
    pop ax
    inc bx
    call solve3
    ret
update3:
    mov best_err, bl
    pop bx
    mov best_ans, bl
    pop cx
    pop ax
    inc bx
    call solve3
    ret
    
calc3:
    xchg cx, bx
    mov ah, 0
    mov al, xs[bx]
    mul cl
    push dx
    mov dl, ys [bx]
    mov dh, 0
    cmp ax, dx
    jl case13
    cmp dx, ax
    jl case23
    xchg cx, bx
    inc cx
    pop dx
    call loop3
    ret
    
case13:
    push dx
    mov dl, labels [bx]
    cmp dl, 0
    je inc_ans3
    xchg bx, cx
    pop dx
    pop dx
    inc cx
    call loop3
    ret
    
case23:
    push dx
    mov dl, labels [bx]
    cmp dl, 1
    je inc_ans3
    xchg bx, cx
    pop dx
    pop dx
    inc cx
    call loop3
    ret
    

inc_ans3:
    inc cur_ans
    pop dx
    xchg bx, cx
    inc cx
    call loop3
    ret
    
    


DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 
DEFINE_PTHIS
ret
codeseg ends
end start