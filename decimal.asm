.include "macro.asm"
.include "dec_io.asm"
.text

.global main
main:  # чтение и запись 10-го числа со знаком
    li s0, 0  # число
    li s1, 0  # знак
    
    call read_signed_decimal
    mv s0, a0
    mv, s1, a1
    
    mv a0, s0
    mv a1, s1
    call print_signed_dicimal
    exit 0