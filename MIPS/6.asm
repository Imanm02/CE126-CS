.text
	jal input
	
	lw $t0,n
	lw $t1,m
	add $t1, $t1, $t0
	move $a0, $t1
	move $a1, $t0
	jal choose_n_k
	move $t0, $v0
	
	li $v0, 4
    la $a0, msgres
    syscall
	
	move $a0, $t0
	li $v0, 1
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
    
    li $v0, 4
    la $a0, msgm
    syscall
    
    li $v0, 5
    syscall
    sw $v0, m
    
    jr $ra
.globl choose_n_k
choose_n_k:
	# $a0 -> n
	# $a1 -> k
	la $v0,1
	move $t0, $a0
	move $t1, $a1
	sub $t3, $a0, $a1
Loop:
	beq $t1,1,Multi
	div $v0, $t1
	mfhi $t2
	bne $t2,0,Multi
Divide:
	mflo $v0
	addi $t1, $t1, -1
	j Loop
Multi:
	beq $t0,$t3,Exit
	mult $v0, $t0
	mflo $v0
	addi $t0, $t0, -1
	j Loop
Exit:
	bne $t1,1,Loop
	jr $ra
.data
n:	.word 0
m:	.word 0
msgn:	.asciiz "Enter n: \n\r"
msgm:	.asciiz "Enter m: \n\r"
msgres:	.asciiz "Number of ways to execute two programs one with n lines and the other with m lines simultaneously and independently is: "
