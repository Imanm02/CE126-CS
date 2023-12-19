.data
    input_msg: .asciiz "enter input string: "
    output_msg_le: .asciiz "left index: "
    new_line: .asciiz "\n"
    output_msg_ri: .asciiz "right index: "
    str: .space 100
    sz: .word 0
    le: .word 0
    ri: .word 0
.text
main:
    la $a0,input_msg
    li $v0,4
    syscall
    la $a0,str
    li $a1,100
    li $v0,8
    syscall
    li $t1,1
    li $a0,0
    lop_odd:
        li $a1,0
        chk_odd:
            add $a1,$a1,$t1
            sub $a2,$a0,$a1
            add $a3,$a0,$a1
            li $t2,0
            li $t3,0
            lb $t2,str($a2)
            lb $t3,str($a3)
            beq $t2,$t3,chk_odd
        sub $a1,$a1,$t1
        add $a2,$a1,$a1
        add $a2,$a2,$t1
        lw $a3,sz
        ble $a2,$a3,pass_odd
        sw $a2,sz
        sub $a2,$a0,$a1
        add $a3,$a0,$a1
        sw $a2,le
        sw $a3,ri
        pass_odd:
        add $a0,$a0,$t1
        li $a1,0
        lb $a1,str($a0)
        li $a2,0
        bne $a1,$a2,lop_odd
    li $a0,0
    lop_even:
        li $a1,-1
        chk_even:
            add $a1,$a1,$t1
            sub $a2,$a0,$a1
            add $a3,$a0,$a1
            add $a3,$a3,$t1
            li $t2,0
            li $t3,0
            lb $t2,str($a2)
            lb $t3,str($a3)
            beq $t2,$t3,chk_even
        sub $a1,$a1,$t1
        add $a2,$a1,$a1
        add $a2,$a2,$t1
        add $a2,$a2,$t1
        lw $a3,sz
        ble $a2,$a3,pass_even
        sw $a2,sz
        sub $a2,$a0,$a1
        add $a3,$a0,$a1
        add $a3,$a3,$t1
        sw $a2,le
        sw $a3,ri
        pass_even:
        add $a0,$a0,$t1
        li $a1,0
        lb $a1,str($a0)
        li $a2,0
        bne $a1,$a2,lop_even
    la $a0,output_msg_le
    li $v0,4
    syscall
    lw $a0,le
    li $v0,1
    syscall
    la $a0,new_line
    li $v0,4
    syscall
    la $a0,output_msg_ri
    li $v0,4
    syscall
    lw $a0,ri
    li $v0,1
    syscall
    
        
            
            
