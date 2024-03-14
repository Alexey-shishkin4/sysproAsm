j main
.include "macro.asm"
.include "hex_io.asm"
.text

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

mul:
    li t1, 0
mul_1:
    andi t2, a0, 1
    beqz t2, skip_shift
    sll t3, a1, t0
    add t1, t1, t3
skip_shift:
    addi t0, t0, 1
    srli a0, a0, 1
    bnez a0, mul_1
    mv a0, t1
    ret


multiply_hex:
    li t0, 0  # результат

    mv t1, a0
    mv t2, a1

multiply_loop:
    andi t3, t2, 0xF
    mul t4, t1, t3 
    slli t0, t0, 4
    add t0, t0, t4

    srli t2, t2, 4

    bnez t2, multiply_loop
    mv a0, t0
    ret