.text
read_hex:
    li t5, 10
    li t1, 0
input_loop:
    readch
    beq a0, t5, end_read
    addi t0, a0, -48
    li t2, 9
    ble t0, t2, hex_digit
    addi t0, t0, -7
hex_digit:
    slli t1, t1, 4
    add t1, t1, t0
    j input_loop
end_read:
    mv a0, t1
    ret


print_hex:
    mv t5, a0
    li a0, '\n'
    printch
    mv t3, t5
    li a0, 0
    beqz t3, print_after_count
count_bytes:
    srli t3, t3, 4
    beqz t3, print_after_count
    addi a0, a0, 4
    j count_bytes
print_after_count:
    mv t4, a0
print_loop:
    srl t3, t5, t4
    li t0, 10
    bge t3, t0, symb_to_ascii
    addi a0, t3, 48
    j print_char
symb_to_ascii:
    addi a0, t3, 55
print_char:
    printch
    sll t3, t3, t4
    sub t5, t5, t3
    beqz t4, end_print
    addi t4, t4, -4
    j print_loop
end_print:
    ret


read_sign:
    readch
    mv t6, a0
    li a0, '\n'
    printch
    mv a0, t6
    ret


multiply_hex:
    li t0, 1  # индекс бита
    li t1, 0  # результат

multiply_loop:
    beqz a1, end_multiply
    
    andi t2, a1, 1
    beqz t2, next_bit
    
    sll t3, a0, t0  # умножаем a на 2^i
    add t1, t1, t3
    
next_bit:
    srli a1, a1, 1
    addi t0, t0, 1
    j multiply_loop

end_multiply:
    srli t1, t1, 1
    mv a0, t1
    ret


division_by_10:  # x/10 = x/8 - x/4*1/10
    li t0, 9
    ble a0, t0, ret_zero
    
    srli t0, a0, 3  # /= 8
    push2 ra, t0
    
    srli a0, a0, 2  # /= 4
    call division_by_10
    
    pop2 ra, t0
    sub a0, t0, a0  # x/8 - x/4*1/10
    ret

ret_zero:
    li a0, 0
    ret

mod10:  # x - 10*div10(x)
    push2 ra, t0
    mv t0, a0
    call division_by_10
    # x*2 + x*8 = x*10
    slli t1, a0, 1
    slli t2, a0, 3
    add a0, t1, t2
    
    sub a0, t0, a0
    pop2 ra, t0
    ret