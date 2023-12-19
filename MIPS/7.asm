.data
    input_msg_x: .asciiz "enter string x: "
    input_msg_a: .asciiz "enter string a: "
    input_msg_b: .asciiz "enter string b: "
    output_msg_cnt: .asciiz "count of a in x: "
    output_msg_string: .asciiz "result string: "
    new_line: .asciiz "\n"
    x: .space 100
    a: .space 100
    b: .space 100
    ans: .space 100
    cnt: .word 0
.text
main:
    la $a0,input_msg_x
    li $v0,4
    syscall
    la $a0,x
    li $a1,100
    li $v0,8
    syscall
    
    la $a0,input_msg_a
    li $v0,4
    syscall
    la $a0,a
    li $a1,100
    li $v0,8
    syscall
    
    la $a0,input_msg_b
    li $v0,4
    syscall
    la $a0,b
    li $a1,100
    li $v0,8
    syscall
    
    li $t0,0
    li $a0,0
    li $t1,1
    li $t6,10
    lop:
        li $a1,0
        chk:
            add $a2,$a0,$a1
            li $t2,0
            li $t3,0
            lb $t2,x($a2)
            lb $t3,a($a1)
            bne $t2,$t3,pass_bad
            add $a1,$a1,$t1
            li $t2,0
            lb $t2,a($a1)
            beq $t2,$t6,pass_good
            b chk
        pass_bad:
            li $t2,0
            lb $t2,x($a0)
            sb $t2,ans($t0)
            add $t0,$t0,$t1
            add $a0,$a0,$t1
            b aft
        pass_good:
            lw $t4,cnt
            add $t4,$t4,$t1
            sw $t4,cnt
            add $a0,$a0,$a1
            li $a1,0
            add_b:
                li $t2,0
                lb $t2,b($a1)
                sb $t2,ans($t0)
                add $t0,$t0,$t1
                add $a1,$a1,$t1
                li $t2,0
                lb $t2,b($a1)
                bne $t2,$t6,add_b
        aft:
            li $t2,0
            lb $t2,x($a0)
            bne $t2,$t6,lop
            
    la $a0,output_msg_cnt
    li $v0,4
    syscall
    lw $a0,cnt
    li $v0,1
    syscall 
    
    la $a0,new_line
    li $v0,4
    syscall
    la $a0,output_msg_string
    li $v0,4
    syscall
    la $a0,ans
    li $v0,4
    syscall
    