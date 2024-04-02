division_by_10:  # x/10 = (x/4 - x/2 * 1/10)/2
    li t0, 9
    ble a0, t0, ret_zero
    
    srli t0, a0, 2  # /= 4
    push2 ra, t0
    
    srli a0, a0, 1  # /= 2
    call division_by_10  # x/2 * 1/10 -> a0
    
    pop2 ra, t0  # x/4 -> t0
    sub a0, t0, a0  # x/8 - x/4*1/10
    srli a0, a0, 1
    ret

ret_zero:
    li a0, 0
    ret

mod10:  # x - 10*div10(x)
    mv t0, a0
    push2 ra, t0
    call division_by_10
    # x*2 + x*8 = x*10
    slli t1, a0, 1
    slli t2, a0, 3
    add a0, t1, t2
    
    pop2 ra, t0
    sub a0, t0, a0
    ret
    
    
    
multiply_32bit:
    li t0, 1  # индекс бита
    li t1, 0  # результат
    li t4, 0xf0000000  # маска для знака
    
check_signs:
    and t5, a0, t4
    and t6, a1, t4
    
    beqz t5, second_sign
    sub a0, zero, a0
    
second_sign:
    beqz t6, multiply_loop
    sub a1, zero, a1

multiply_loop:
    beqz a1, add_sign_multiply
    
    andi t2, a1, 1
    beqz t2, next_bit
    
    sll t3, a0, t0  # умножаем a на 2^i
    add t1, t1, t3
    
next_bit:
    srli a1, a1, 1
    addi t0, t0, 1
    j multiply_loop

add_sign_multiply:
    srli t1, t1, 1
    mv a0, t1
    beq t5, t6, end_multiply
    sub a0, zero, a0
end_multiply:
    ret