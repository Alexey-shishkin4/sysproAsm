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
    li t4, 10
    li t3, 0
    li s3, 0  # тут первое число

input_loop:
    readch
    
    beq a0, t4, end_input
    
    slli s3, s3, 16
    add s3, s3, t3
    li t3, 0
   
    
    mv t0, a0
    addi t0, t0, -48

binary_conversion_loop:
    andi t1, t0, 1        # Получаем младший бит числа t0
    srli t0, t0, 1
    addi sp, sp, -4       # Резервируем место в стеке для хранения бита
    sw t1, 0(sp)          # Записываем младший бит в стек
    bnez t0, binary_conversion_loop

assemble_result_loop:
    lw t1, 0(sp)          # Загружаем бит из стека
    addi sp, sp, 4        # Освобождаем занимаемое им место в стеке
    slli t3, t3, 4        # Сдвигаем результат влево на один бит
    addi s0, s0, 1
    add t3, t3, t1        # Добавляем бит к t3
    
    li s1, 0x7fffeffc
    bne sp, s1, assemble_result_loop  # Если стек не пуст, продолжаем сборку результата
    j input_loop


end_input:
    slli s3, s3, 16
    add s3, s3, t3
    
    li t4, 10,
    li t5, 0
    li s4, 0  # второе число

input_loop2:
    readch
    
    beq a0, t4, end_prog
    
    slli s4, s4, 16
    add s4, s4, t5
    li t5, 0
    
    mv t0, a0
    addi t0, t0, -48

binary_conversion_loop1:
    andi t1, t0, 1        # Получаем младший бит числа t0
    srli t0, t0, 1
    addi sp, sp, -4       # Резервируем место в стеке для хранения бита
    sw t1, 0(sp)          # Записываем младший бит в стек
    bnez t0, binary_conversion_loop1

assemble_result_loop1:
    lw t1, 0(sp)          # Загружаем бит из стека
    addi sp, sp, 4        # Освобождаем занимаемое им место в стеке
    slli t5, t5, 4        # Сдвигаем результат влево на один бит
    add t5, t5, t1        # Добавляем бит к t3
    
    li s1, 0x7fffeffc
    bne sp, s1, assemble_result_loop1  # Если стек не пуст, продолжаем сборку результата
    j input_loop2
    
end_prog:
    slli s4, s4, 16
    add s4, s4, t5
    exit 0
