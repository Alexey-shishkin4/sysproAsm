.text
.macro syscall %n
    li a7, %n
    ecall
.end_macro

.macro readch
    syscall 12
.end_macro

.macro printch
    syscall 11
.end_macro

.macro exit %ecode
    li a0, %ecode
    syscall 93
.end_macro

main:
    li s1, 0  # первое число
    li s2, 0  # второе число
    li s3, 0  # знак
    
    call read_num
    mv s1, a0
    
    call read_sign
    mv s3, a0
    
    call read_num
    mv s2, a0
    
    li t0, '+'
    beq s3, t0, add_numbers
    li t0, '-'
    beq s3, t0, sub_numbers
    li t0, '&'
    beq s3, t0, bit_and
    li t0, '|'
    beq s3, t0, bit_or
    
add_numbers:
    add a0, s1, s2
    j end_main
sub_numbers:
    sub a0, s1, s2
    j end_main
bit_and:
    and a0, s1, s2
    j end_main
bit_or:
    or a0, s1, s2

end_main:
    call print_result
    exit 0


print_result:
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


read_num:
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


read_sign:
    readch
    mv t6, a0
    li a0, '\n'
    printch
    mv a0, t6
    ret