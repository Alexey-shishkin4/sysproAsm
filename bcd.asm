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
    
    beq a0, t4, end_input1
    
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
    
end_input1:
    slli s4, s4, 16
    add s4, s4, t5
    
    # считывание операции
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
    li t6, 0x000f       # Маска для получения младших четырех битов

    # Начинаем сложение с младших разрядов
    li t5, 0            # Инициализация переноса
    li s5, 0            # Счетчик разрядов

add_loop:
    and t1, s3, t6      # Получаем младшие 4 бита из s3
    and t2, s4, t6      # Получаем младшие 4 бита из s4
    add t3, t1, t2      # Складываем цифры из обоих чисел
    add t3, t3, t5      # Добавляем перенос
    add t5, zero, zero  # Обнуляем перенос

    # Обработка переноса между разрядами
    li s6, 10
    bge t3, s6, carry_addition  # Проверка, нужен ли перенос
    j no_carry_addition

carry_addition:
    li t5, 1             # Устанавливаем флаг переноса
    addi t3, t3, -10     # Коррекция результата

no_carry_addition:
    slli a2, a2, 4       # Сдвигаем результат влево на 4 бита
    add a2, a2, t3       # Добавляем результат сложения к общему результату
    srli s3, s3, 4       # Сдвигаем число s3 вправо на 4 бита
    srli s4, s4, 4       # Сдвигаем число s4 вправо на 4 бита

    addi s5, s5, 1       # Увеличиваем счетчик разрядов
    li s6, 8             # Проверяем, достигли ли мы конца 32-битного BCD числа
    bne s5, s6, add_loop

    # Если есть перенос после последнего разряда, добавляем его к результату
    beqz t5, print_number
    addi a2, a2, 1

sub_numbers:
    li a2, 0            # Инициализация результата
    li t6, 0x000f       # Маска для получения младших четырех битов

    # Начинаем вычитание с младших разрядов
    li t5, 0            # Инициализация заема
    li s5, 0            # Счетчик разрядов

subtract_loop:
    and t1, s3, t6      # Получаем младшие 4 бита из s3
    and t2, s4, t6      # Получаем младшие 4 бита из s4
    sub t3, t1, t2      # Вычитаем цифры s4 из s3
    sub t3, t3, t5      # Вычитаем заем
    add t5, zero, zero  # Обнуляем заем

    # Обработка заема между разрядами
    bgez t3, no_borrow_subtraction  # Проверка, нужен ли заем
    j borrow_subtraction

no_borrow_subtraction:
    slli a2, a2, 4       # Сдвигаем результат влево на 4 бита
    add a2, a2, t3       # Добавляем результат вычитания к общему результату
    srli s3, s3, 4       # Сдвигаем число s3 вправо на 4 бита
    srli s4, s4, 4       # Сдвигаем число s4 вправо на 4 бита

    addi s5, s5, 1       # Увеличиваем счетчик разрядов
    li s6, 8             # Проверяем, достигли ли мы конца 32-битного BCD числа
    bne s5, s6, subtract_loop

    # Результат вычитания теперь хранится в регистре a2
    j print_number

borrow_subtraction:
    li t5, 1             # Устанавливаем флаг заема
    addi t3, t3, 10      # Коррекция результата

    j no_borrow_subtraction

print_number:
    li t4, '0'
    
    beqz a2, end_print

    # Извлекаем младшую цифру из числа в t3
    andi t6, a2, 0xF        # Маскируем остальные биты, чтобы получить только младшие 4
    add t6, t6, t4         # Преобразуем цифру в ASCII-символ

    # Устанавливаем аргумент для печати
    mv a0, t6               # Передаем текущую цифру для печати
    li a7, 11               # Код вызова для печати символа
    ecall                   # Вызов системного вызова

    # Сдвигаем число вправо на 4 бита, чтобы извлечь следующую цифру
    srli a2, a2, 4

    # Вызываем функцию для печати следующей цифры
    jal ra, print_number

end_print:
    exit 0