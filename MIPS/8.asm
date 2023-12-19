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

.macro print_str (%label)
	.text
        li $v0, 4
        la $a0, %label
        syscall
.end_macro

.macro read_int (%res)
    li $v0, 5
    syscall
    move %res, $v0
.end_macro

.macro read_int_v0 ()
    li $v0, 5
    syscall
.end_macro

.macro read_char_v0 ()
    li $v0, 12
    syscall
.end_macro

.macro print_char_a0 ()
    li $v0, 11
    syscall
.end_macro

# returns size in v0
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

# to ascii a0 -> v0
.macro to_ascii() 
    addi  $a1,$zero,0
    blt   $a0,$a1, exit_not_valid
    addi  $a1,$zero,15
    bgt   $a0,$a1, exit_not_valid

    addi  $a1,$zero,0x9
    ble   $a0,$a1, Less
    addi $v0, $a0, 0x37
    j Out
    Less:
        addi $v0, $a0, 0x30
    Out:
.end_macro


# from ascii a0 -> v0
.macro from_ascii() 
    addi  $a1,$zero,0x30
    blt   $a0,$a1, exit_not_valid
    addi  $a1,$zero,0x46
    bgt   $a0,$a1, exit_not_valid

    addi  $a1,$zero,0x39
    ble   $a0,$a1, Less
    addi $v0, $a0, -55
    j Out
    Less:
        addi $v0, $a0, -0x30
    Out:
.end_macro


start_prog:
    print_stri("Enter the number X\: ")
    read_string(value_str)
    print_stri("Enter Its base (base_b): ")
    read_int_v0() # base_b
    move $s1, $v0
    blt $v0, 2, exit_not_valid
    bgt $v0, 16, exit_not_valid

    addi $t0, $zero, 0 # counter
    addi $s0, $zero, 0 # value in base
    loop_calculate:
        lb $t1, value_str($t0)
        beq $t1, 10, out_loop_calculate
        mult $s0, $s1
        mfhi $s0
        bne $s0, 0, exit_overflow
        mflo $s0
        move $a0, $t1
        from_ascii()
        add  $s0, $s0, $v0
        add $t0, $t0, 1
        j loop_calculate
    out_loop_calculate:    
    # now s0 is our value

    print_stri("Enter second base (base_a): ")
    read_int_v0() # base_a

    blt $v0, 2, exit_not_valid
    bgt $v0, 16, exit_not_valid

    move $s1, $v0
    addi $t0, $zero, 0 # counter

    loop_store:
        div $s0, $s1
        mfhi $a0
        to_ascii()
        sb $v0, result_str($t0)
        addi $t0, $t0, 1
        mflo $s0
        bne $s0, 0, loop_store
    out_loop_store:

    print_stri("The Result is: ")
    loop_print:
        addi $t0, $t0, -1
        lb $a0, result_str($t0)
        print_char_a0()
        bgt $t0, 0, loop_print

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

value_str:  .space 100 # should be init with zeros
result_str: .space 100