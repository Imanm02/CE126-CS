dseg	segment

    evalstr db "12-4/2+(5-3)","$"
    rpn db 30 dup("$")
    value dw ?
    dividebyzero_errmsg db "division by zero!$"
    parantheses_errmsg db "parentheses don't match!$"
    overflow_errmsg db "overflow!$"
    invalidstr_errmsg db "invalid input string!$"
	
dseg	ends


sseg	segment

    words dw 100 dup(?)
	
sseg	ends


cseg	segment

		assume  cs:cseg, ds:dseg,ss:sseg
	main:
		mov ax, dseg
		mov ds, ax
		mov es, ax
		mov ax, sseg
		mov ss, ax
		mov sp, offset words + 98
		mov bp, sp
		call convert2rpn
		mov dx, offset rpn
		call evaluaterpn
		mov bx, value

		mov ax, 4C00h
		int 21h


    convert2rpn proc near ; shunting-yard algorithm
        mov bp, sp
        mov si, offset evalstr
        mov di, offset rpn
        cld
      
	getchar: 
        lodsb
        cmp al, "$"
        je endstr
        cmp al, 30h
        jb porop
        cmp al, 39h
        ja porop
        stosb
        jmp getchar
    
	porop:
        cmp al, "("
        je leftp
        cmp al, ")"
        je rightp
	op:
        cmp al, "+"
        je addorsub
        cmp al, "-"
        je addorsub
        cmp al, "*"
        je mulordiv
        cmp al, "/"
        je mulordiv
		jmp invalidstr_err
		
	addorsub:
        cmp sp, bp
        jge emptystack
        pop cx
        push cx
        cmp cl, "+"
        je popop
        cmp cl, "-"
        je popop

    mulordiv:
        cmp sp, bp
        jge emptystack
        pop cx
        push cx
        cmp cl, "*"
        je popop
        cmp cl, "/"
        je popop
    
    emptystack:
        cmp al, "("
        je parantheses_err
        push ax
        mov al, " "
        stosb
        jmp getchar
    
    popop:
        pop cx
        xchg ax, cx
        stosb
        xchg ax, cx
        jmp op 
 
    leftp:
        push ax
        jmp getchar
    
    rightp:
        cmp sp, bp
        jge parantheses_err
        pop cx
        push cx
        cmp cl, "("
        je matchedp
        pop cx
        xchg ax, cx
        stosb
        xchg ax, cx
        jmp rightp
    
    matchedp:
        pop cx
        jmp getchar
    
        
    endstr:
        cmp sp, bp
        jge stackend
        pop ax
        cmp al, "("
        je parantheses_err
        stosb
        jmp endstr
    
    stackend:
        mov dx, offset rpn
        ret
    
 convert2rpn endp 
 
 
 evaluaterpn proc near
 
        mov si, offset rpn
    gettoken:
        mov dl, byte ptr [si]
        mov dh, 0
        cmp dl, 30h
        jb nonnum
        cmp dl, 39h
        ja nonnum
        mov ax, 0
        mov bx, 0
        mov cl, 0Ah
    
    getnum:
        sub dl, 30h     
        mul cl
        add ax, dx
        inc si
        mov dl, byte ptr [si]
        cmp dl, 30h
        jb endgetnum
        cmp dl, 39h
        ja endgetnum
        jmp getnum

    endgetnum:
        push ax
        mov ax, 0
    
    nonnum:
        inc si
        cmp dl, " "
        je gettoken 
        cmp dl, "+"
        je addop
        cmp dl, "-"
        je subop
        cmp dl, "*"
        je mulop
        cmp dl, "/"
        je divop
        pop ax
        mov value, ax
        ret
    
	; operations
    addop:
        pop bx
        pop ax
        add ax, bx
        jo overflow_err
        push ax
        jmp gettoken
    
    subop:
        pop bx
        pop ax
        sub ax, bx
        jo overflow_err
        push ax 
        jmp gettoken
    
    mulop:
        pop bx
        pop ax
        mul bx
        cmp dx, 0
        jne overflow_err
        push ax
        jmp gettoken
    
    divop:
        pop bx
        cmp bx, 0
        je dividebyzero_err
        pop ax
        cwd
        div bx
        push ax
        jmp gettoken

 ; errors
    dividebyzero_err:
        mov dx, offset dividebyzero_errmsg
        mov ah, 9
        int 21h
        mov ax, 4c00h
        int 21h

    parantheses_err:
        mov dx, offset parantheses_errmsg
        mov ah, 9
        int 21h
        mov ax, 4c00h
        int 21h
    
    overflow_err:
        mov dx, offset overflow_errmsg 
        mov ah, 9
        int 21h
        mov ax, 4c00h
        int 21h     
		
	invalidstr_err:
		mov dx, offset invalidstr_errmsg 
        mov ah, 9
        int 21h
        mov ax, 4c00h
        int 21h


cseg	ends 
 
end main
