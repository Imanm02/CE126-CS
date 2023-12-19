.text
	jal input
	la $s2,0
	move $s1, $v0
	lw $s0, n
	
	la $a0, 0
	jal place_queens
	
	li $v0, 1
	move $a0, $s2
	syscall
	
    li $v0, 10
    syscall
.globl input
input:

	li $v0, 4
    la $a0, msgn
    syscall
    
    li $v0, 5
    syscall
    sw $v0, n
    
    move $a0, $v0
    li $v0, 9
    syscall
    
    jr $ra
.globl place_queens
place_queens:
	beq $a0,$s0,AddAns
	move $s3,$a0
	la $s4,0
Loop:
	beq $s4,$s0,Exit
	
	move $a0,$s3
	move $a1,$s4
	
	addi $sp,$sp, -4
	sw $ra,0($sp)
	
	jal check_cell
	
	lw $ra,0($sp)
	addi $sp, $sp, 4
	
	beq $v0,1,Continue
	
	la $t0, 4
	mult $t0,$s3
	mflo $t0
	add $t0, $t0, $s1
	sw $s4,0($t0)
	
	addi $sp,$sp, -12
	sw $s3,8($sp)
	sw $s4,4($sp)
	sw $ra,0($sp)
	
	addi $a0, $s3, 1
	jal place_queens
	
	lw $ra,0($sp)
	lw $s4,4($sp)
	lw $s3,8($sp)
	addi $sp, $sp, 12
	
	
	la $t0, 4
	mult $t0,$s3
	mflo $t0
	add $t0, $t0, $s1
	la $t1,0
	sw $t1,0($t0)
	
Continue:
	addi $s4,$s4,1
	j Loop
AddAns:
	addi $s2,$s2,1
Exit:
	jr $ra
.globl check_cell
check_cell:
	move $t1,$a1
	move $t2,$a1
	la $v0,0
check_loop:
	addi $a0, $a0, -1
	addi $t1, $t1, -1
	addi $t2, $t2, 1
	beq $a0,-1,exit_check
	
	la $t3,4
	mult $t3,$a0
	mflo $t3
	add $t3, $s1, $t3
	
	lw $t4,0($t3)

	beq $t4,$a1,return_1
	
	beq $t4,$t1,return_1
	
	beq $t4,$t2,return_1

	j check_loop
return_1:
	la $v0,1
exit_check:
	jr $ra
.data
n:	.word 0
ans: .word 0
msgn:	.asciiz "Enter n: \n\r"
msgres:	.asciiz "Answer is: "
