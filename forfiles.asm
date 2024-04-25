loadfile:
    push2 ra, a0
    call flen
    mv t1, a0
    
    addi a0, a0, 1
    
    pop2 ra, t0
    sbrk
    push2 ra, a0
    
    mv a1, a0  # addres of buffer
    mv a0, t0  # file descriptor
    mv a2, t1  # max length to read
    readfile
    
    pop2 ra, a0
    ret


flen:
    mv t1, a0

    li a1, 0
    li a2, 1
    lseek
    mv t2, a0

    mv a0, t1
    li a2, 2
    lseek

    mv t3, a0
    mv a0, t1
    mv a1, t2
    li a2, 0
    lseek

    mv a0, t3
    ret
	

countlines:
    li t0, 0  # count
    li a1, '\n'
    push ra
    
    addi a0, a0, -1
countlines_loop:
    addi t0, t0, 1
    addi a0, a0, 1
    push t0
    call strchr
    pop t0
    bnez a0, countlines_loop
    mv a0, t0
    pop ra
    ret


strchr:
    lb t0 0(a0)
    addi a0, a0, 1
    beq t0, zero, error_strchr
    bne t0, a1, strchr

    addi a0, a0, -1
    ret
error_strchr:
    li a0, 0
    ret