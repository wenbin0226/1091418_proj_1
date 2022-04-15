.globl	main
.eqv MAX 100 #MAX = 100
.data
    Input:	.string "Input a number:\n" #Input string
    Output:	.string "The damage:\n" #Output string
.text
main:
    la a0, Input
    li a7, 4
    ecall #print Input
    li a7, 5
    ecall #input a number
    
    #make constants
    addi t0, zero, 1 #1
    addi t1, zero, 10 #10
    addi t2, zero, 20 #20
    
    li t6, MAX #t6 = 100
    bge a0, t6, end #x >= 100
    jal ra, function #call f(x)
    
    mv t0, a0 #put f(x) in t0
    
    la a0, Output
    li a7, 4
    ecall #print Output
    
    mv a0, t0
    li a7, 1
    ecall #print f(x)
end:
    li a7, 10
    ecall #exit
function:
    beq a0, zero, case0 # x == 0
    beq a0, t0, case1 # x == 1
    bgt a0, t2, case20_ # x > 20
    bgt a0, t1, case10_20 # 10 < x <= 20
    bgt a0, t0, case1_10 # 1 < x <= 10
    j caseOther #otherwise
case0:
    li a0, 1 #f(x) = 1
    ret #return
case1:
    li a0, 5 #f(x) = 5
    ret #return
case20_:
    addi sp, sp, -16 #make stack
    sd ra, 8(sp)
    sd a0, 0(sp)
    addi t3, zero, 5 #make constants
    div a0, a0, t3 #x /= 5
    jal ra, function #call f(x / 5)
    
    addi t3, zero, 2 #make constants
    ld t4, 0(sp) #t4 = x
    mul t3, t3, t4 #x *= 2
    
    add a0, a0, t3 #f(x) = 2*x + f(x / 5)
    
    ld ra, 8(sp) #ra = return address
    addi, sp, sp, 16 #delete stack
    ret #return
case10_20:
    addi sp, sp, -16 #make stack
    sd ra, 8(sp)
    sd a0, 0(sp)
    
    addi a0, a0, -2 #x -= 2
    jal ra, function #call f(x - 2)
    ld t3, 0(sp) #t3 = x
    sd a0, 0(sp) #put f(x - 2) in stack
    
    addi a0, t3, -3 #x -= 3
    jal ra, function #call f(x - 3)
    ld t3, 0(sp) #t3 = f(x - 2)
    add a0, a0, t3 #f(x) = f(x - 2) + f(x - 3)
    
    ld ra, 8(sp) #ra = return address
    addi sp, sp, 16 #delete stack
    ret #return
case1_10:
    addi sp, sp, -16 #make stack
    sd ra, 8(sp)
    sd a0, 0(sp)
    
    addi a0, a0, -1 #x -= 1
    jal function #call f(x - 1)
    ld t3, 0(sp) #t3 = x
    sd a0, 0(sp) #put f(x - 1) in stack
    
    addi a0, t3, -2 #x -= 2
    jal function #call f(x - 2)
    ld t3, 0(sp) #t3 = f(x - 1)
    add a0, a0, t3 #f(x) = f(x - 1) + f(x - 2)
    
    ld ra, 8(sp) #ra = return address
    addi sp, sp, 16 #delete stack
    ret #return
caseOther:
    li a0, -1 # = -1
    ret #return
