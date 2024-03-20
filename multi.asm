.include "macro.asm"
.include "hex_io.asm"
.text


.global main
main:
    li s1, 0  # Первое число
    li s2, 0  # Второе число

    call read_hex
    mv s1, a0

    call read_hex
    mv s2, a0
    
    mv a0, s1  # первое число
    mv a1, s2  # второе число
    call multiply_hex

    call print_hex
end_prog:
    exit 0
