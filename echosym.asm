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
    li t0, 10
read_loop:
    readch
    printch
    beq a0, t0, exit_prog
    addi a0, a0, 1
    printch
    j read_loop
exit_prog:
    exit 0
