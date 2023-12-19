.data
bestx: .word 0
besty: .word 0

errorx: .word 0x7fffffff
errory: .word 0x7fffffff

bestx_y: .word 0
errorx_y: .word 0x7fffffff

max_x: .word 0
max_y: .word 0
min_x: .word 0
min_y: .word 0

enter: .ascii "\n"
string1: .asciiz "best x partition: "
string2: .asciiz "with error: "
string3: .asciiz "best y partition: "
string4: .asciiz "best point: "
.text

.macro push (%arg)
addi $sp,$sp,-4
sw %arg,0($sp)
.end_macro
.macro push_m (%a1,%a2,%a3)
push(%a1)
push(%a2)
push(%a3)
.end_macro

.macro load_element(%array,%pos,%load)
push(%pos)
sll %pos,%pos,2
add %pos,%pos,%array
lw %load,(%pos)
pop(%pos)
.end_macro

.macro save_element(%array,%pos,%save)
push(%pos)
sll %pos,%pos,2
add %pos,%pos,%array
sw %save,(%pos)
pop(%pos)
.end_macro

.macro print_int(%int)
push($v0)
push($a0)
move $a0,%int
li $v0,1
syscall
lb $a0,enter
li $v0,11
syscall
pop($a0)
pop($v0)
.end_macro

.macro print_string(%label)
la $a0,%label
li $v0,4
syscall
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


main:


li $v0,5
syscall			
move $s0,$v0	#move n to S0

move $a0,$s0
sll $a0,$a0,2
li $v0,9
syscall 			#create mem
move $s1,$v0  	

li $v0,9
syscall
move $s2,$v0		# create mem

li $v0,9
syscall
move $s3,$v0  		

move $s4,$zero 		

move $t0,$zero		# t0 = i: 0 - n-1

li $t1,0x7fffffff	# t1 = minimum x
li $t2,0x80000001	# t2 = maximum x
li $t3,0x7fffffff	# t3 = minimum y
li $t4,0x80000001	# t4 = maximum y

sw $t1,min_x
sw $t2,max_x
sw $t3,min_y
sw $t4,max_y

loop1:	
	li $v0,5
	syscall
	save_element($s3,$t0,$v0)	#read labels
	beqz $v0,label_zero1
	addi $s4,$s4,1
	label_zero1:
	li $v0,5
	syscall
	save_element($s1,$t0,$v0)	#read x
	
	bge $v0,$t1,no_change_xmin
	move $t1,$v0
	no_change_xmin:
	ble $v0,$t2,no_change_xmax
	move $t2,$v0
	no_change_xmax:
	
	
	li $v0,5
	syscall
	save_element($s2,$t0,$v0)	#read y
	bge $v0,$t3,no_change_ymin
	move $t3,$v0
	no_change_ymin:
	ble $v0,$t4,no_change_ymax
	move $t4,$v0
	no_change_ymax:
	addi $t0,$t0,1
	bne $t0,$s0,loop1
	
sw $t1,min_x
sw $t2,max_x
sw $t3,min_y
sw $t4,max_y
sub $s5,$s0,$s4 			# s5 = number of 0 labels

#finding best x partition

lw $t0 ,min_x # t0 = x : min(x) ~ max(x)	
loop2:
	move $t8,$zero # t8 = 1's before x
	move $t9, $zero # t9 = 0's before x
	move $t1,$zero 	#t1 = i : 0~n-1

	loop3:
		load_element($s1,$t1,$t4) #t4 = x[i]
		load_element($s3,$t1,$t5) #t5 = label[i]
		bge $t4,$t0,above1
			beqz $t5,not_zero2
				addi $t8,$t8,1	# t8 = 1's before x
				b zero2
			not_zero2:
				addi $t9,$t9,1	# t9 = 0's before x
			zero2:
		above1:
		addi $t1,$t1,1
		bne $t1,$s0,loop3
	sub $t6,$s4,$t8		# t6 = 1's after x
	sub $t7,$s5,$t9		# t7 = 0's after x
	add $t6,$t6,$t9		# t6 = error for 1/0
	add $t7,$t7,$t8		# t7 = error for 0/1
	ble $t6,$t7,t6_is_min
		move $t6,$t7
	t6_is_min:
	lw $t7,errorx
	bgt $t6,$t7,not_min
		sw $t6,errorx
		sw $t0,bestx
	not_min:
	addi $t0,$t0,1
	lw $t6,max_x  		# t6 = max_x
	bne $t0,$t6,loop2
lw $t1,bestx
lw $t2,errorx
print_string(string1)
print_int($t1)
print_string(string2)
print_int($t2)

#finding best y partition
lw $t0 ,min_y # t0 = y : min(y) ~ max(y)	
loop20:	
	move $t8,$zero # t8 = 1's before line
	move $t9, $zero # t9 = 0's before line
	move $t1,$zero 	#t1 = i : 0~n-1
	loop30:
		load_element($s2,$t1,$t4) #t4 = y[i]
		load_element($s3,$t1,$t5) #t5 = label[i]
		bge $t4,$t0,above10
			beqz $t5,not_zero20
				addi $t8,$t8,1	# t8 = 1's before y
				b zero20
			not_zero20:
				addi $t9,$t9,1	# t9 = 0's before y
			zero20:
		above10:
		addi $t1,$t1,1
		bne $t1,$s0,loop30
	sub $t6,$s4,$t8		# t6 = 1's after y
	sub $t7,$s5,$t9		# t7 = 0's after y
	add $t6,$t6,$t9		# t6 = error for 1/0
	add $t7,$t7,$t8		# t7 = error for 0/1
	ble $t6,$t7,t6_is_min0
		move $t6,$t7
	t6_is_min0:
	lw $t7,errory
	bgt $t6,$t7,not_min0
		sw $t6,errory
		sw $t0,besty
	not_min0:
	addi $t0,$t0,1
	lw $t6,max_y		# t6 = max_y
	bne $t0,$t6,loop20
	
lw $t1,besty
lw $t2,errory
print_string(string3)
print_int($t1)
print_string(string2)
print_int($t2)


#finding best x partition

li $t0 ,-20 # t0 = a : -20 ~ 20)	
loop200:
	move $t8,$zero # t8 = 1's under x/y
	move $t9, $zero # t9 = 0's under x/y
	move $t1,$zero 	#t1 = i : 0~n-1
	loop300:
		load_element($s1,$t1,$t4) #t4 = x[i]
		load_element($s3,$t1,$t5) #t5 = label[i]
		load_element($s2,$t1,$t6) # t6 = y[i]
		mul $t4,$t4,$t0  # t4 = a*x[i]
		bge $t6,$t4,above100
			beqz $t5,not_zero200
				addi $t8,$t8,1	# t8 = 1's under x/y
				b zero200
			not_zero200:
				addi $t9,$t9,1	# t9 = 0's under x/y
			zero200:
		above100:
		addi $t1,$t1,1
		bne $t1,$s0,loop300
	sub $t6,$s4,$t8		# t6 = 1's above x
	sub $t7,$s5,$t9		# t7 = 0's above x
	add $t6,$t6,$t9		# t6 = error for 1/0
	add $t7,$t7,$t8		# t7 = error for 0/1
	ble $t6,$t7,t6_is_min00
		move $t6,$t7
	t6_is_min00:
	lw $t7,errorx_y
	bgt $t6,$t7,not_min00
		sw $t6,errorx_y
		sw $t0,bestx_y
	not_min00:
	addi $t0,$t0,1
	bne $t0,21,loop200

lw $t1,bestx_y
lw $t2,errorx_y

print_string(string4)
print_int($t1)
print_string(string2)
print_int($t2)

li $v0, 10		#terminate
syscall