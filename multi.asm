.include "macro.asm"
.include "hex_io.asm"
.text


.global main
main:
    li s1, 0  # ������ �����
    li s2, 0  # ������ �����

    call read_hex
    mv s1, a0

    call read_hex
    mv s2, a0
    
    mv a0, s1  # ������ �����
    mv a1, s2  # ������ �����
    call multiply_hex

    call print_hex
end_prog:
    exit 0
