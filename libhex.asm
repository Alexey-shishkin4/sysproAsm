.text
.include "macros.s"

read_num:
    li t5, 10
    li a1, 0
input_loop:
    readch
    
    beq a0, t5, quit
    addi t0, a0, -48
    li t2, 9
    ble t0, t2, hex_digit
    addi t0, t0, -7
hex_digit:
    slli a1, a1, 4
    add a1, a1, t0
    
    j input_loop
    
read_sign:
    readch
    mv t6, a0
    li a0, '\n'
    printch
    ret

quit:
    ret

count_bytes:
	li a0, 0
	beqz a1, quit
count_bytes_loop:
	srli a1, a1, 4
	beqz a1, quit
	addi a0, a0, 4
	j count_bytes_loop

num_to_ascii:
	li t0, 10
	bge a1, t0, symb_to_ascii
	addi a0, a1, 48
	ret
symb_to_ascii:
	addi a0, a1, 55
	ret
