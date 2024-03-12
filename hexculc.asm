.text
.macro syscall %n
    li a7, %n
    ecall
.end_macro

.macro readch
    syscall 12
.end_macro

.macro printch
    syscall 11
.end_macro

.macro exit %ecode
    li a0, %ecode
    syscall 93
.end_macro

main:
    li s1, 0  # ������ �����
    li s2, 0  # ������ �����
    li s3, 0  # ����
    
    jal ra, read_num
    mv s1, a0
    
    call read_sign
    mv s3, a0
    
    call read_num
    mv s2, a0
    
    li t0, '+'
    beq s3, t0, add_numbers
    li t0, '-'
    beq s3, t0, sub_numbers
    li t0, '&'
    beq s3, t0, bit_and
    li t0, '|'
    beq s3, t0, bit_or
    
end_main:
    # � a0 ��������� ��������
    call print_result

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
    j end_main


print_result:
    mv t5, a0
    li a0, '\n'
    printch
    mv a1, t5
    call count_bytes
    mv s5, a0
    call print_loop

print_loop:
    srl a1, t5, s5
    call num_to_ascii
    printch
    sll a1, a1, s5
    sub t5, t5, a1
    beqz s5, end_prog
    addi s5, s5, -4
    j print_loop

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


read_num:
    li t5, 10
    li t1, 0
input_loop:
    readch
    
    beq a0, t5, end_read
    addi t0, a0, -48
    li t2, 9
    ble t0, t2, hex_digit
    addi t0, t0, -7
hex_digit:
    slli t1, t1, 4
    add t1, t1, t0
    
    j input_loop
end_read:
    mv a0, t1
    ret
    
read_sign:
    readch
    mv t6, a0
    li a0, '\n'
    printch
    mv a0, t6
    ret

quit:
    ret
    
end_prog:
    exit 0
