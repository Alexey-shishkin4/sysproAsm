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

.macro to_digit
    addi a0, a0, '0'
.end_macro


main:
    li t4, 10
    li t3, 0
    li s3, 0  # ��� ������ �����

input_loop:
    readch
    
    beq a0, t4, end_input
    
    slli s3, s3, 16
    add s3, s3, t3
    li t3, 0
   
    
    mv t0, a0
    addi t0, t0, -48

binary_conversion_loop:
    andi t1, t0, 1        # �������� ������� ��� ����� t0
    srli t0, t0, 1
    addi sp, sp, -4       # ����������� ����� � ����� ��� �������� ����
    sw t1, 0(sp)          # ���������� ������� ��� � ����
    bnez t0, binary_conversion_loop

assemble_result_loop:
    lw t1, 0(sp)          # ��������� ��� �� �����
    addi sp, sp, 4        # ����������� ���������� �� ����� � �����
    slli t3, t3, 4        # �������� ��������� ����� �� ���� ���
    addi s0, s0, 1
    add t3, t3, t1        # ��������� ��� � t3
    
    li s1, 0x7fffeffc
    bne sp, s1, assemble_result_loop  # ���� ���� �� ����, ���������� ������ ����������
    j input_loop


end_input:
    slli s3, s3, 16
    add s3, s3, t3
    
    li t4, 10,
    li t5, 0
    li s4, 0  # ������ �����

input_loop2:
    readch
    
    beq a0, t4, end_input1
    
    slli s4, s4, 16
    add s4, s4, t5
    li t5, 0
    
    mv t0, a0
    addi t0, t0, -48

binary_conversion_loop1:
    andi t1, t0, 1        # �������� ������� ��� ����� t0
    srli t0, t0, 1
    addi sp, sp, -4       # ����������� ����� � ����� ��� �������� ����
    sw t1, 0(sp)          # ���������� ������� ��� � ����
    bnez t0, binary_conversion_loop1

assemble_result_loop1:
    lw t1, 0(sp)          # ��������� ��� �� �����
    addi sp, sp, 4        # ����������� ���������� �� ����� � �����
    slli t5, t5, 4        # �������� ��������� ����� �� ���� ���
    add t5, t5, t1        # ��������� ��� � t3
    
    li s1, 0x7fffeffc
    bne sp, s1, assemble_result_loop1  # ���� ���� �� ����, ���������� ������ ����������
    j input_loop2
    
end_input1:
    slli s4, s4, 16
    add s4, s4, t5
    
    # ���������� ��������
    readch
    mv t6, a0
    li t0, '+'
    beq t6, t0, add_numbers
    li t0, '-'
    beq t6, t0, sub_numbers

add_numbers:
    mv a0, s3
    mv a1, s4
    li a2, 0
    li t6, 0x000f       # ����� ��� ��������� ������� ������� �����

    # �������� �������� � ������� ��������
    li t5, 0            # ������������� ��������
    li s5, 0            # ������� ��������

add_loop:
    and t1, s3, t6      # �������� ������� 4 ���� �� s3
    and t2, s4, t6      # �������� ������� 4 ���� �� s4
    add t3, t1, t2      # ���������� ����� �� ����� �����
    add t3, t3, t5      # ��������� �������
    add t5, zero, zero  # �������� �������

    # ��������� �������� ����� ���������
    li s6, 10
    bge t3, s6, carry_addition  # ��������, ����� �� �������
    j no_carry_addition

carry_addition:
    li t5, 1             # ������������� ���� ��������
    addi t3, t3, -10     # ��������� ����������

no_carry_addition:
    slli a2, a2, 4       # �������� ��������� ����� �� 4 ����
    add a2, a2, t3       # ��������� ��������� �������� � ������ ����������
    srli s3, s3, 4       # �������� ����� s3 ������ �� 4 ����
    srli s4, s4, 4       # �������� ����� s4 ������ �� 4 ����

    addi s5, s5, 1       # ����������� ������� ��������
    li s6, 8             # ���������, �������� �� �� ����� 32-������� BCD �����
    bne s5, s6, add_loop

    # ���� ���� ������� ����� ���������� �������, ��������� ��� � ����������
    beqz t5, print_number
    addi a2, a2, 1

sub_numbers:
    li a2, 0            # ������������� ����������
    li t6, 0x000f       # ����� ��� ��������� ������� ������� �����

    # �������� ��������� � ������� ��������
    li t5, 0            # ������������� �����
    li s5, 0            # ������� ��������

subtract_loop:
    and t1, s3, t6      # �������� ������� 4 ���� �� s3
    and t2, s4, t6      # �������� ������� 4 ���� �� s4
    sub t3, t1, t2      # �������� ����� s4 �� s3
    sub t3, t3, t5      # �������� ����
    add t5, zero, zero  # �������� ����

    # ��������� ����� ����� ���������
    bgez t3, no_borrow_subtraction  # ��������, ����� �� ����
    j borrow_subtraction

no_borrow_subtraction:
    slli a2, a2, 4       # �������� ��������� ����� �� 4 ����
    add a2, a2, t3       # ��������� ��������� ��������� � ������ ����������
    srli s3, s3, 4       # �������� ����� s3 ������ �� 4 ����
    srli s4, s4, 4       # �������� ����� s4 ������ �� 4 ����

    addi s5, s5, 1       # ����������� ������� ��������
    li s6, 8             # ���������, �������� �� �� ����� 32-������� BCD �����
    bne s5, s6, subtract_loop

    # ��������� ��������� ������ �������� � �������� a2
    j print_number

borrow_subtraction:
    li t5, 1             # ������������� ���� �����
    addi t3, t3, 10      # ��������� ����������

    j no_borrow_subtraction

print_number:
    li t4, '0'
    
    beqz a2, end_print

    # ��������� ������� ����� �� ����� � t3
    andi t6, a2, 0xF        # ��������� ��������� ����, ����� �������� ������ ������� 4
    add t6, t6, t4         # ����������� ����� � ASCII-������

    # ������������� �������� ��� ������
    mv a0, t6               # �������� ������� ����� ��� ������
    li a7, 11               # ��� ������ ��� ������ �������
    ecall                   # ����� ���������� ������

    # �������� ����� ������ �� 4 ����, ����� ������� ��������� �����
    srli a2, a2, 4

    # �������� ������� ��� ������ ��������� �����
    jal ra, print_number

end_print:
    exit 0