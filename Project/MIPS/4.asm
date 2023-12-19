.text

.macro print_int (%x)
    li $v0, 1
    add $a0, $zero, %x
    syscall
.end_macro

.macro print_stri (%str)
	.data
        myLabel: .asciiz %str
	.text
        li $v0, 4
        la $a0, myLabel
        syscall
.end_macro

.macro read_int_v0 ()
    li $v0, 5
    syscall
.end_macro

.macro read_char_v0 ()
    li $v0, 12
    syscall
.end_macro

.macro read_string(%ptr) 
    la $a0, %ptr
    li $v1, 0
    Loop:
    read_char_v0()
    sb $v0, 0($a0)
    add $v1, $v1, 1
    add $a0, $a0, 1
    bne $v0, 10, Loop
    addi $v0, $v1, -1
.end_macro

.macro push (%reg)
    addi $sp, $sp, -4
    sw %reg, 0($sp)
.end_macro

.macro pushf (%reg)
    addi $sp, $sp, -4
    s.s %reg, 0($sp)
.end_macro

.macro pop (%reg)
    lw %reg, 0($sp)
    addi $sp, $sp, 4
.end_macro

.macro popf (%reg)
    l.s %reg, 0($sp)
    addi $sp, $sp, 4
.end_macro

.macro start_call()
    push($ra)
.end_macro

.macro end_call()
    pop($ra)
    jr $ra
.end_macro

.macro call(%label)
    jal %label
.end_macro

.macro print_float3(%f)
    pushf(%f)
    pushf($f11)

    abs.s $f11, %f
    c.eq.s $f11, %f
    bc1t is_positive    
    print_stri("-")

    is_positive:
    mov.s %f, $f11

    cvt.w.s $f11, %f
    mfc1 $t0, $f11
    print_int($t0)
    cvt.s.w $f11, $f11
    sub.s %f, %f, $f11

    print_stri(".")

    mul.s %f, %f, $f10
    cvt.w.s $f11, %f
    mfc1 $t0, $f11
    print_int($t0)
    cvt.s.w $f11, $f11
    sub.s %f, %f, $f11

    mul.s %f, %f, $f10
    cvt.w.s $f11, %f
    mfc1 $t0, $f11
    print_int($t0)
    cvt.s.w $f11, $f11
    sub.s %f, %f, $f11

    mul.s %f, %f, $f10
    cvt.w.s $f11, %f
    mfc1 $t0, $f11
    print_int($t0)
    cvt.s.w $f11, $f11
    sub.s %f, %f, $f11

    popf($f11)
    popf(%f)
.end_macro

#   s0  current char
#   f0  result of last function call
#   set f10 to be 10 float
#   set f2 to be 0

start_init:
    la $sp, stack
    addi $sp, $sp, 800
    
    li $t0, 10
    mtc1 $t0, $f10
    cvt.s.w  $f10, $f10  # f0 is float 10

    li $t0, 0
    mtc1 $t0, $f2
    cvt.s.w  $f2, $f2  # f0 is float 10
end_init:
j start_prog

get:
    start_call()
    loop_get:
    read_char_v0()
    move $s0, $v0
    beq $s0, ' ', loop_get
    end_call()

read_number:
    start_call()
    mtc1 $zero, $f0
    cvt.s.w  $f0, $f0  # f0 is float 10
    loop_read_number:
        blt $s0, '0', end_loop_read_number
        bgt $s0, '9', end_loop_read_number
        addi $t0, $s0, -0x30        
        mtc1 $t0, $f1  # use f1 as temp
        cvt.s.w $f1, $f1
        mul.s $f0, $f0, $f10
        add.s $f0, $f0, $f1

        read_char_v0()
        move $s0, $v0

        j loop_read_number
    end_loop_read_number:
    bne $s0, ' ', end_read_number
    call(get)
    end_read_number:
    end_call()

read_cr:
    start_call()
    beq $s0, '(', read_cr_open
    blt $s0, '0', exit_not_valid
    bgt $s0, '9', exit_not_valid
    j read_cr_number
    read_cr_open:
        call(get)
        call(read_expr)
        bne $s0, ')', exit_not_valid
        call(get)
        end_call()
    read_cr_number:
        call(read_number)
        end_call()

read_md:
    start_call()
    call(read_cr)
    read_md_loop:
        beq $s0, '*', read_md_case_star
        beq $s0, '/', read_md_case_slash
        end_call()
        read_md_case_star:
        call(get)
        pushf($f0)
        call(read_cr)
        popf($f1) # f1 is old value
        mul.s $f0, $f1, $f0
        j read_md_loop
        read_md_case_slash:
        call(get)
        pushf($f0)
        call(read_cr)
        popf($f1)
        mov.s $f3, $f0
        abs.s $f3, $f3   # absolute value
        c.le.s $f3, $f2
        bc1t exit_divide_by_zero    # check division by zero
        div.s $f0, $f1, $f0
        j read_md_loop

read_expr:
    start_call()
    call(read_md)    
    beq $s0, '+', read_expr_case_plus
    beq $s0, '-', read_expr_case_neg
    end_call()
    read_expr_case_plus:
        call(get)
        pushf($f0)
        call(read_expr)
        popf($f1)        
        add.s  $f0, $f1, $f0
        end_call()
    read_expr_case_neg:
        call(get)
        pushf($f0)
        call(read_expr)
        popf($f1)
        sub.s  $f0, $f1, $f0
        end_call()


start_prog:
    print_stri("Please enter the expression to evaluate\: ")
    call(get)
    call(read_expr)
    bne $s0, '\n', exit_not_valid
    print_stri("The result is\: ")
    print_float3($f0)
end_prog:

j exit

exit_divide_by_zero:
print_stri("Divide by zero happened")
j exit

exit_overflow:
print_stri("There was an overflow")
j exit

exit_not_valid:
print_stri("The input is invalid")
j exit

exit:

.data

stack:    .word   200