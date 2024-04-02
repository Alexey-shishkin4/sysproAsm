.include "macro.asm"
.include "hex_io.asm"
.include "operations.asm"
.text


.global main
main:
    li s1, 0  # число
    li s2, 0  # результат деления на 10
    li s3, 0  # результат остатка на 10
    
    call read_hex
    mv s1, a0
    
    call division_by_10
    mv s2, a0
    
    mv a0, s1
    call mod10
    mv s3, a0
    
    mv a0, s2
    call print_hex
    mv a0, s3
    call print_hex
    exit 0
