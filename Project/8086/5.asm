.MODEL SMALL

.DATA
    CR EQU 13
    LF EQU 10
    inBuf Label BYTE
    Bsize DB 100
    Rsize DB ?
    inStr DB 100 DUP(0)

    _a DW 0
    _b DW 1

.STACK
    stack_array dw 100h dup(0)

func_intro MACRO
        push	bp
        mov	bp,sp
        push	di
        push	si
ENDM
func_outro MACRO
        pop	si
        pop	di
        pop	bp
ENDM

.CODE

    input PROC
        func_intro
        lea dx,inBuf
        mov ah,0AH
        int 21h
        lea bx,inStr
        mov cl,Rsize
        sub ch,ch
        mov si,cx
        mov byte ptr[bx+si],'$'
        func_outro
        ret
    input ENDP

    new_line PROC
        func_intro
        mov dl,CR
        mov ah,02
        int 21h
        mov dl,LF
        mov ah,02
        int 21H
        func_outro
        ret
    new_line ENDP

    output PROC
        func_intro
        call new_line
        lea dx,si
        mov ah,09
        int 21h
        func_outro
        ret



    input_num PROC
        func_intro
        xor bx,bx
        loop:
        lodsb
        cmp al,'0'
        jb noascii
        cmp al,'9'
        ja noascii
        sub al,30h
        cbw
        push ax
        mov ax,bx
        mov cx,10
        mul cx
        mov bx,ax
        pop ax
        add bx,ax
        jmp loop
        noascii:
        func_outro
        ret

    input_num ENDP

    output_num PROC
        func_intro
        call new_line
        mov cx, 0
        mov bx, 10
        mov	ax,4[bp]
        loophere:
        mov dx, 0
        div bx
        push ax
        add dl, '0'
        pop ax
        push dx
        inc cx
        cmp ax, 0
        jnz loophere
        mov ah, 2
        loophere2:
        pop dx
        int 21h
        loop loophere2
        func_outro
        ret
    output_num ENDP

    cal_fact PROC
        func_intro
        mov	ax,4[bp]
        test	ax,ax
        jne 	continue_fact
        mov	ax,1
        func_outro
        ret
        continue_fact:
        mov	ax,4[bp]
        dec	ax
        push	ax
        call cal_fact
        inc	sp
        inc	sp
        mov	cx,4[bp]
        imul	cx
        func_outro
        ret
    cal_fact ENDP

    cal_fib PROC
        func_intro
        mov	ax,4[bp]
        cmp	ax,1
        jg  	continue_fib
        mov	ax,[_b]
        func_outro
        ret
        continue_fib:
        jmp check_1_fib
        body_fib:
        mov	ax,[_b]
        add	ax,[_a]
        mov	[_b],ax
        mov	ax,[_b]
        sub	ax,[_a]
        mov	[_a],ax
        mov	ax,4[bp]
        dec	ax
        mov	4[bp],ax
        check_1_fib:
        mov	ax,4[bp]
        cmp	ax,1
        jg 	body_fib
        mov	ax,[_b]
        func_outro
        ret


    cal_fib ENDP



    MAIN PROC
        mov ax,DATA
        mov ds,ax

        mov ax,STACK
        mov ss,ax

        lea sp,stack_array + 200h

        call input
        lea dx,inStr
        mov si,dx
        call input_num
        push bx
        call cal_fact
        push bx
        mov bx,ax
        call cal_fib
        sub bx,ax
        push bx
        call output_num





        EXIT:
            mov ah,4ch
            int 21h

    MAIN ENDP


END MAIN