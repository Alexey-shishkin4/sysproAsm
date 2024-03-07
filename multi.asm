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
    li t3, 0  # Первое число
    li t4, 0  # Второе число
    li t5, 10  # Значение ASCII-кода символа '10'

input_loop1:
    readch
    
    beq a0, t5, end_input1  # Если введенное число равно 10, завершаем ввод первого числа
    
    mv t0, a0
    addi t0, t0, -48  # Преобразуем ASCII в число
    slli t3, t3, 4
    add t3, t3, t0     # Добавляем новую цифру
    
    j input_loop1

end_input1:
    li a0, '\n'
    printch  # Печатаем символ новой строки

input_loop2:
    readch
    
    beq a0, t5, end_input2  # Если введенное число равно 10, завершаем ввод второго числа
    
    mv t0, a0
    addi t0, t0, -48  # Преобразуем ASCII в число
    slli t4, t4, 4
    add t4, t4, t0     # Добавляем новую цифру
    
    j input_loop2

end_input2:
    # умножение
    li t0, 0
    li t1, 0
mul_1:
    andi t2, t3, 1
    beqz t2, skip_shift
    sll s1, t4, t0
    add t1, t1, s1
skip_shift:
    addi t0, t0, 1
    srli t3, t3, 1
    bnez t3, mul_1
    # результат в t1
    mv t5, t1

print_result:
    li a0, '\n'
    printch
    mv a1, t5
    jal ra, count_bytes
    mv s5, a0
    jal ra, print_loop

print_loop:
    srl a1, t5, s5
    call num_to_ascii
    printch
    sll a1, a1, s5
    sub t5, t5, a1
    beqz s5, end_prog
    addi s5, s5, -4
    j print_loop

end_prog:
    exit 0
 

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

quit:
    ret