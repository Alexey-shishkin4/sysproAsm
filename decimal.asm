.include "macro.asm"
.include "dec_io.asm"
.text

.global main
main:  # ������ � ������ 10-�� ����� �� ������
    li s0, 0  # �����
    li s1, 0  # ����
    
    call read_signed_decimal
    mv s0, a0
    mv, s1, a1
    
    mv a0, s0
    mv a1, s1
    call print_signed_dicimal
    exit 0