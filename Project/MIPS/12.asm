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

.macro push (%reg)
    addi $sp, $sp, -4
    sw %reg, 0($sp)
.end_macro

.macro pop (%reg)
    lw %reg, 0($sp)
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

j start_prog

func: # input in a0 output in v0
    start_call()
        bgt $a0, 1, start_solve
        addi $v0, $zero, 1
        end_call()
        start_solve:
        addi $t1, $zero, 2 # t1 = 2
        div $a0, $t1
        mfhi $t0 # t0 = reminder
        mflo $a0 # a0 /= 2
        push($t0)
        call(func)
        pop($t0) # restore t0
        mult $v0, $t1 
        mflo $v0 # v0 *= 2

        beq $t0, 0, is_even
        is_odd:
        addi $v0, $v0, 1
        j end_if
        is_even:
        addi $v0, $v0, -1
        end_if:
    end_call()
end_func:    


start_prog:
    la $sp, stack
    addi $sp, $sp, 800

    print_stri("Enter number n\: ")
    read_int_v0()
    move $a0, $v0
    call(func)
    move $s0, $v0
    print_stri("The answer is: ")
    print_int($s0)

end_prog:

j exit

exit_divide_by_zero:
print_stri("Divide by zero")
j exit

exit_overflow:
print_stri("Overflow")
j exit

exit_not_valid:
print_stri("The input is invalid")
j exit

exit:

.data

stack:    .word   200