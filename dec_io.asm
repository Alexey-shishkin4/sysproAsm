.text

read_signed_decimal:
    li t5, 10
    li t1, 0 # результат
    li t2, 0 # знак
    readch
    li t0, '-'
    beq a0, t0, set_negative
    beq a0, t5, end_read
    addi a0, a0, -48
    bge a0, t5, read_error
    j add_digit
set_negative:
    li t2, 1
read_loop:
    readch
    beq a0, t5, end_read
    addi a0, a0, -48
    bge a0, t5, read_error
add_digit:
    slli t1, t1, 4
    add t1, t1, a0
    j read_loop
end_read:
    mv a0, t1
    mv a1, t2
    ret
read_error:
    exit 0


print_signed_dicimal:  #a0 - число, a1 - знак
    mv t5, a0
    li a0, '\n'
    printch
    li t0, 1
    beq a1, t0, print_minus
    j continue_print
print_minus:
    li a0, '-'
    printch
continue_print:
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