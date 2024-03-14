.include "macro.asm"
.include "hex_io.asm"
.text


.global main
main:
    li s1, 0  # ������ �����
    li s2, 0  # ��������� ������� �� 10
    li s3, 0  # ��������� ������� �� 10
    
    call read_hex
    mv s1, a0
    
    call division_by_10
    mv s2, a0
    mv s3, a1
    
    mv a0, s2
    call print_hex
    mv a0, s3
    call print_hex
    exit 0


division_by_10:
    li t1, 16
    li t2, 0  # �������

division_loop:
    bge a0, t1, divide
    j end_division
divide:
    sub a0, a0, t1
    addi t2, t2, 1	
    j division_loop
end_division:
    mv a1, a0  # �������
    mv a0, t2
    ret