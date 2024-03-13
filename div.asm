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
    li s2, 0  # результат деления на 10
    li s3, 0  # результат остатка на 10
    
    call read_hex
    mv s1, a0
    
    call division_by_10
    mv s2, a0
    mv s3, a1
    
    mv a0, s2
    call print_hex
    mv a0, s3
    call print_hex
    exit 0
    
    


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


division_by_10:
    # для деления в 16-ой сс на 10 достатчно сдвинуть на 4 вправо, но тут имитация деления в 10-ой сс
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