  .data
  
  z:.float 0
  one: .float 1
  mo: .float -1
  two: .float 2
  dr: .float 0
  db: .float 0
  t:.asciiz "please enter for number(a1,b1,a2,b2)"
  s:.asciiz " and "
  
  
  .text
  
    li $v0, 4  
    la $a0, t
    syscall #print t
  
  # Getting user input
    li $v0, 5
    syscall
    move $s0,$v0
    
    li $v0, 5
    syscall
    move $s1,$v0
    
    li $v0, 5
    syscall
    move $s2,$v0
    
    li $v0, 5
    syscall
    move $s3,$v0
    
   mul $t0,$s0,$s2
   mul $t1,$s1,$s3
   add $t0,$t0,$t1  #t0=a1a2+b1b2
   mul $t1,$s1,$s2
   mul $t2,$s3,$s0
   sub $t1,$t1,$t2  #t1=b1a2-a1b2
   mul $t2,$s2,$s2
   mul $t3,$s3,$s3
   add $t2,$t2,$t3 #t2=s2*s2+s3*s3
   
   mtc1 $t0, $f12
   cvt.s.w $f12, $f12 #t0=f12
   
   mtc1 $t1, $f11
   cvt.s.w $f11, $f11 #t1=f11
   
   mtc1 $t2, $f10  
   cvt.s.w $f10, $f10 #t2=f10
   
  
   div.s $f0,$f12,$f10 #f0=t0/t2
   div.s $f1,$f11,$f10 #f1=t1/t2
   mul.s $f3,$f0,$f0
   mul.s $f4,$f1,$f1
   add.s $f3,$f3,$f4 #f3=t0^2+t1^2
   sqrt.s $f3,$f3  #=r
   
   div.s $f0,$f1,$f0 #f0=f1/f0=x
   
   la $t0,z
   lwc1 $f1,0($t0) #f1=0=res
   
   la $t0,one
   lwc1 $f2,0($t0) #f2=1=neg
   
   la $t0,mo
   lwc1 $f30,0($t0) #f30=-1
   
   la $t0,two
   lwc1 $f28,0($t0) #f28=2
   
   mov.s $f4,$f0 #f4=x=power
   mov.s $f5,$f2 #f5=1=div
   
   li $s3,0 #counter
arctan_loop:
   beq $s3,100,end
   mul.s $f7,$f2,$f4
   div.s $f8,$f7,$f5
   add.s $f1,$f1,$f8 #res+=neg*power/div
   
   mul.s $f2,$f2,$f30 #neg*=-1
   
   mul.s $f29,$f0,$f0
   
   mul.s $f4,$f4,$f29   #power*=x^2
   
   add.s $f5,$f5,$f28  #div+=2
   
   add $s3,$s3,1   #counter++
   
   j arctan_loop #loop
end:
     
   la $s0,dr
   swc1 $f3,0($s0) #store r
   
   la $s0,db
   swc1 $f1,0($s0) #store beta
   
   
  li $v0, 2
  mov.s $f12, $f3   
  syscall
  
  li $v0, 4  
   la $a0, s
   syscall #print t
  
  li $v0, 2
  mov.s $f12, $f1   
  syscall