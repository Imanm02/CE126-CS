.data
enter: .ascii "\n"
space: .ascii " "

.macro exit
	li $v0, 10
	syscall
.end_macro 


.macro push (%arg)
addi $sp,$sp,-4
sw %arg,0($sp)
.end_macro
.macro push_m (%a1,%a2,%a3)
push(%a1)
push(%a2)
push(%a3)
.end_macro


.macro pop(%arg)
lw %arg,0($sp)
addi $sp,$sp,4
.end_macro	

.macro pop_m(%a1,%a2,%a3)
pop(%a1)
pop(%a2)
pop(%a3)
.end_macro


.macro element_pos (%row,%column) #get row and column, return position byte in v0
mul $v0,%row,$s0
add $v0,$v0,%column
sll $v0,$v0,2
.end_macro


.macro load_element(%array,%row,%column) #get row and column and array and load word in v0
element_pos (%row,%column)
add $v0,$v0,%array
lw $v0,0($v0)
.end_macro

.macro load_element_into(%array,%row,%column,%dest) #get row and column and array and load word in %dest
element_pos (%row,%column)
add $v0,$v0,%array
lw %dest,0($v0)
.end_macro

.macro store_element(%array,%row,%column) #store a0 into position
element_pos(%row,%column)
add $v0,$v0,%array
sw $a0,0($v0)
.end_macro

.macro print(%matrix)
push($t0)
push($t1)
move $t0,$zero #row
fori:
	move $t1,$zero #column
	forj:
		load_element(%matrix,$t0,$t1)
		move $a0,$v0
		li $v0,1
		syscall
		lb $a0,space
		li $v0,11
		syscall
		addi $t1,$t1,1
		bne  $t1,$s0,forj
	lb $a0,enter
	li $v0,11
	syscall
	addi $t0,$t0,1
	bne $t0,$s0,fori
lb $a0,enter
li $v0,11
syscall
pop($t1)
pop($t0)
.end_macro


.macro muladd_row(%matrix,%f_row,%s_row,%mul) # f_row <- f_row + s_row*mul
push_m($t0,$t1,$t2)
push($t3)
push($t4)
move $t2,%f_row
move $t3,%s_row
move $t4,%mul
move $t0,$zero
fori:
	load_element(%matrix,$t2,$t0)
	move $t1,$v0
	load_element(%matrix,$t3,$t0)
	mul $v0,$v0,$t4
	add $a0,$t1,$v0
	store_element(%matrix,$t2,$t0)
	addi $t0,$t0,1
	bne $t0,$s0,fori
print(%matrix)
pop($t4)
pop($t3)
pop_m($t2,$t1,$t0)
.end_macro


# i represents immediate data
.macro muladd_rowi(%matrix,%f_rowi,%s_rowi,%muli) # f_rowi <- f_rowi + s_rowi*muli
push_m($t7,$t6,$t5)
li $t7,%f_rowi
li $t6,%s_rowi
li $t5,%muli
muladd_row(%matrix,$t7,$t6,$t5)
pop_m($t5,$t6,$t7)
.end_macro

.macro mul_row(%matrix,%row,%mul) # row <- row*mul
push(%mul)
addi %mul,%mul,-1
muladd_row(%matrix,%row,%row,%mul)
pop(%mul)
.end_macro

.macro mul_rowi(%matrix,%rowi,%muli) # rowi <- rowi*muli
push($t7)
push($t6)
li $t7,%rowi
li $t6,%muli
mul_row(%matrix,$t7,$t6)
pop($t6)
pop($t7)
.end_macro


.text
main:
li $v0,5
syscall 			#read n in s0

move $s0,$v0 		# s0 <- n
mul $a0,$s0,$s0 		# s1 <- n^2
sll $a0,$a0,2 		# s1 <- (n^2)*4

li $v0,9 
syscall 
move $s1,$v0 		# allocating memory in s1 for matrix

li $v0,9
syscall			#allocating memory in s2 for identity marix
move $s2,$v0

read_matrix:
move $t0,$zero #t0 <- row			reading matrix elements
fori:
	move $t1,$zero #t1 <- column
	forj:
		li $v0,5
		syscall
		move $a0,$v0 #read aij
		store_element($s1,$t0,$t1) # build in matrix
		li $a0,0
		bne $t0,$t1,not_diameter
		li $a0,1
		not_diameter:
		store_element($s2,$t0,$t1) #build identity matrix
		addi $t1,$t1,1
		bne  $t1,$s0,forj
	addi $t0,$t0,1
	bne $t0,$s0,fori


make_matrix_paiin_mosalasi:
move $t0,$zero		#t0 <- column:0~n-1
sub $t2,$s0,1
pm_fori:
	addi $t1,$t0,1    	#t1 <- row:i+1 ~ n-1
	pm_forj:
		move $a0,$t1
		move $a1,$t0
		jal make_element_zero
		addi $t1,$t1,1
		bne $t1,$s0,pm_forj
	addi $t0,$t0,1
	bne $t0,$t2,pm_fori
exit_pm:


make_matrix_bala_mosalasi:
subi $t0,$s0,1   #t0 <- column:n-1~1
bm_fori:
	subi $t1,$t0,1   #t1 <- row: i-1~0
	bm_forj:
		move $a0,$t1
		move $a1,$t0 
		jal make_element_zero
		subi $t1,$t1,1
		bne $t1,-1,bm_forj
	subi $t0,$t0,1
	bne $t0,$zero,bm_fori
			
exit

#arguments:
#$a0 <- row index
#$a1 <- column index
make_element_zero:
	push($ra)
	push_m($t0,$t1,$t2)
	push($t3)
	push_m($t4,$t5,$t6)
	move $t0,$a0		#t0 <- row
	move $t1,$a1		#t1 <- column
	load_element_into($s1,$t0,$t1,$t2)   # we want to make t2 element zero 
	beqz $t2,exit_mez
	bge $t2,$zero,t2_not_negative
	li $t4,-1
	mul_row($s1,$t0,$t4)
	mul_row($s2,$t0,$t4)
	neg $t2,$t2
	t2_not_negative:
	load_element_into($s1,$t1,$t1,$t3)   #using a multiplier of t3
	bge $t3,$zero,t3_not_negative
	li $t4,-1
	mul_row($s1,$t1,$t4)
	mul_row($s2,$t1,$t4)
	neg $t3,$t3
	t3_not_negative:
	move $a0,$t2
	move $a1,$t3
	jal find_gcd
	move $t4,$v0		#t4 <-gcd(t3,t2)
	div $t4,$t2
	mflo $t5			#t5 <- gcd(t2,t3)/t2
	div $t4,$t3
	mflo $t6			#t6 <- gcd(t2,t3)/t3		
	mul_row($s1,$t0,$t5)
	mul_row($s2,$t0,$t5)
	neg $t6,$t6
	muladd_row($s1,$t0,$t1,$t6)
	muladd_row($s2,$t0,$t1,$t6)
	exit_mez:
	pop_m($t6,$t5,$t4)
	pop_m($t3,$t2,$t1)
	pop($t0)
	pop($ra)
	jr $ra







#$v0 <- gcd($a0,$a1)
find_gcd:
	push($t0)
	push($t1)
	move $v0,$a1
	bge $a0,$a1,a1_is_greater
	move $v0,$a0					#v0 <- max(a1,a0)		
	a1_is_greater:
	gcd_loop:
		div $v0,$a0
		mfhi $t0
		bnez $t0,iter
		div $v0,$a1
		mfhi $t0
		bnez $t0,iter
		pop($t1)
		pop($t0)
		jr $ra
		iter:
		addi $v0,$v0,1
		b gcd_loop
		
		
		
		
