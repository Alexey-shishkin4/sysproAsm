.include "macro.asm"
.include "hex_io.asm"
.text
.globl main

main:  # 12, 2 -> 6
    li s0, 0  # first number
    li s1, 0  # second number
    
    call read_hex
    mv s0, a0
    
    call read_hex
    mv s1, a0
    
    
    mv a0, s0
    mv a1, s1
    call udiv
    
    call print_hex
    
    mv a0, s0
    mv a1, s1
    call sdiv
    
    call print_hex
    exit 0

udiv:
    beqz a1, exit_with_err
    mv t0, a0
    mv t1, a1
    
    push3 ra, t0, t1
    mv a0, t0
    call count_bytes_4div
    mv t2, a0  # кол-во бит в делимом
    pop3 ra, t0, t1
    push3 ra, t0, t1    
    mv a0, t1
    call count_bytes_4div
    mv t3, a0  # кол-во бит в делители
    pop3 ra, t0, t1

    li a0, 0 # res
    
divide_loop:
    sub t4, t2, t3
    bltz t4, end_div
    srl t5, t0, t4
    
    sub t5, t5, t1
    bltz t5, add_zero
    
    slli a0, a0, 1
    addi a0, a0, 1
    j continue_udiv
    
add_zero:
    slli a0, a0, 1
continue_udiv:
    sll t6, t1, t4
    sub t0, t0, t6
    addi t2, t2, -1
    j divide_loop
end_div:
    ret


sdiv:
    beqz a1, exit_with_err
    li t4, 0xf0000000
    and t0, a0, t4  # first sign
    and t1, a1, t4  # second sign
    
    beqz t0, second_sign
    sub a0, zero, a0
second_sign:
    beqz t1, to_div
    sub a1, zero, a1

to_div:
    push3 ra, t0, t1
    call udiv
    pop3 ra, t0, t1
end_sdiv:
    beq t0, t1, to_ret_sdiv
    sub a0, zero, a0
to_ret_sdiv:
    ret


count_bytes_4div:  # t0, a0
	mv t0 a0
	li a0 0
	beq zero t0 _count_bytes_quit
_count_bytes_loop:
	srli t0 t0 1
	addi a0 a0 1
	bne zero t0 _count_bytes_loop
_count_bytes_quit:
	ret
	

exit_with_err:
    exit 1