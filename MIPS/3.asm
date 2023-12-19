.data

     text:  .asciiz "Enter a number: "
     array: .float 400
     array1: .float 400
     array2: .float 400
     array3: .float 400
     array4: .float 400
     array5: .float 400
     array6: .float 400
     array7: .float 400
     array8: .float 400
     array9: .float 400
     array10: .float 400
     array11: .float 400
     array12: .float 400
     array13: .float 400
     array14: .float 400
     
     one: .float 1.0
     dx: .float 0.0001
     z:  .float 0.0
     nope:.asciiz "\nthere is no root "
     
     

.text

 main:
    
    
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall

    # Getting user input
    li $v0, 5
    syscall
    la $t0,array

    # Moving the integer input to another register
    move $s0, $v0  #s0=n
    move $s1,$s0  #counter
l1: beq $s1,-1,end_input
    li $v0, 6
    syscall
    swc1 $f0,($t0)
    addi $t0,$t0,4
    addi $s1,$s1,-1
    j l1
    
end_input:
la $s4,z       #f0=x=0
lwc1 $f0,0($s4)


jal get_result
la $s3,dx
lwc1 $f8,0($s3) #f8=dx

li $s5,0  #counter
cal:
abs.s $f5,$f4 
c.le.s $f5,$f8 #if result<=dx jump to l3
bc1t print_root   
mov.s $f6,$f4 #res
add.s $f0,$f0,$f8 #point=x+dx
jal get_result
sub.s $f9,$f4,$f6
div.s $f9,$f9,$f8   #f9=dy/dx
div.s $f6,$f6,$f9   #f6=res/D
sub.s $f0,$f0,$f8
sub.s $f0, $f0,$f6 #point-= res/D
jal get_result
addi $s5,$s5,1
beq $s5,200,no_ans
j cal

no_ans:
# Printing out the text
    li $v0, 4
    la $a0, nope
    syscall
    j terminate
print_root:
li $v0, 2
mov.s $f12, $f0   # Move contents of register $f3 to register $f12
syscall

terminate:
li $v0,10
syscall




          
       
get_result: #f0=x a1=n #f4=output
move $a1,$s0
la $a2,array
la $t9,one
lwc1 $f1,0($t9) #f1=1=multiplier
la $t9,z
lwc1 $f4, 0($t9)   #f4=0
l2: 
   beq $a1,-1,ret
   lwc1 $f2,0($a2)
   mul.s $f3,$f2,$f1  #f3=mul*array[i]
   add.s $f4,$f4,$f3  #f4=result+=f3
   mul.s $f1,$f1,$f0 #f1*=x
   addi $a1,$a1,-1   #dec a1
   addi $a2,$a2,4
   j l2
ret: jr $ra

   
   
    
        

     
    
