.include "macro.asm"
.include "hex_io.asm"

.text
main:
    li s1, 0  # первое число
    li s2, 0  # второе число
    li s3, 0  # знак
    
    call read_hex
    mv s1, a0
    
    call read_sign
    mv s3, a0
    
    call read_hex
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
    call print_hex
    exit 0