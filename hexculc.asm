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
    li t3, 0  # первое число
    li t4, 0  # второе число
    li t5, 10
    
input_loop1:
    readch
    
    beq a0, t5, end_input1
    mv t0, a0
    addi t0, t0, -48
    li t2, 9
    ble t0, t2, hex_digit1
    addi t0, t0, -7

hex_digit1:
    slli t3, t3, 4
    add t3, t3, t0
    
    j input_loop1

end_input1:
    readch
    mv t6, a0
    li a0, '\n'
    printch

input_loop2:
    readch
    beq a0, t5, end_input2
    mv t0, a0
    addi t0, t0, -48
    li t2, 9
    ble t0, t2, hex_digit2
    addi t0, t0, -7

hex_digit2:
    slli t4, t4, 4
    add t4, t4, t0
    
    j input_loop2

end_input2:
    li t0, '+'
    beq t6, t0, add_numbers
    li t0, '-'
    beq t6, t0, sub_numbers
    li t0, '&'
    beq t6, t0, bit_and
    li t0, '|'
    beq t6, t0, bit_or

add_numbers:
    add t5, t3, t4
    j print_result
    
sub_numbers:
    sub t5, t3, t4
    j print_result
    
bit_and:
    and t5, t3, t4
    j print_result
    
bit_or:
    or t5, t3, t4
    j print_result

print_result:
    exit 0

