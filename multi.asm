j main
.include "macro.asm"
.include "hex_io.asm"
.text

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


multiply_hex:
    li t0, 0  # ���������

    mv t1, a0  # ������ �����
    mv t2, a1  # ������ �����

multiply_loop:
    add t0, t0, t1
    addi t2, t2, -1

    bnez t2, multiply_loop
    mv a0, t0
    ret