.include "macro.asm"
.include "dec_io.asm"
.text

.global main
main:  # чтение и запись 10-го числа со знаком
    li s0, 0  # число
    li s1, 0  # знак
    
    li s2, 0  # второе число
    li s3, 0  # знак
    
    li s4, 0  # результат
    li s5, 0  # знак
    
    call read_signed_decimal
    mv s0, a0
    mv, s1, a1
    
    call read_signed_decimal
    mv s2, a0
    mv s3, a1
    
    readch
    li t0, '+'
    beq a0, t0, addition
    li t0, '-'
    beq a0, t0, to_substraction
    exit 1
to_substraction:
    li t0, 1
    xor s3, s3, t0
    j addition


addition:
    bgtz s1, check_1  # x1 < 0
    # x1 > 0
    bgtz s3, substraction
    add s4, s0, s2
    li s5, 0  # res > 0
    j end_main

check_1:
    beqz s3, subs_alt
    add s4, s0, s2
    li s5, 1 # res < 0
    j end_main

subs_alt:
    swap s0, s2
    swap s1, s3
substraction:
    bgtz s1, check_2  # x1 > 0
    beqz s3, addition  # x2 < 0
    # x2 > 0
    sub s4, s0, s2
    bltz s4, abs
    li s5, 0
    j end_main
abs:
    sub s4, zero, s4
    li s5, 1
    j end_main
check_2:
    bgtz s3, subs_alt
    add s4, s0, s2
    li s5, 1
    j end_main    

end_main:
    # проверить переполнение
    li t0, 0x7FFFFFFF
    srli t0, s4, 31
    bnez t0, overflow_detected
    mv a0, s4
    mv a1, s5
    call print_signed_dicimal
    exit 0
overflow_detected:
    exit 1
