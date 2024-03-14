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
    li t0, 0  # результат
    mv t1, a0  # первое число
    mv t2, a1  # второе число
multiply_loop:
    add t0, t0, t1
    addi t2, t2, -1
    bnez t2, multiply_loop
    mv a0, t0
    ret


division_by_10:
    li t1, 16
    li t2, 0  # счетчик
division_loop:
    bge a0, t1, divide
    j end_division
divide:
    sub a0, a0, t1
    addi t2, t2, 1	
    j division_loop
end_division:
    mv a1, a0  # остаток
    mv a0, t2
    ret
