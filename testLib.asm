.data
begining1: .asciz "Testing function "
begining2: .asciz "...\n"
fail1: .asciz "Test is falied: "
fail2: .asciz ") results in "
fail3: .asciz "expected "
ok: .asciz "OK("
none: .asciz "NONE"
space: .asciz ", "

.macro printch_failed_msg %str_in %char_in %int_act, %int_exp
    la a0 fail1
    printstr
    mv a0 s1
    printstr
    li a0, '('
    printch
    mv a0 %str_in
    printstr
    la a0 space
    printstr
    mv a0 %char_in
    printch
    la a0 fail2
    printstr
    printch_res %int_act
    li a0, ' '
    printch
    la a0 fail3
    printstr
    printch_res %int_exp
    li a0, '\n'
    printch
.end_macro


.macro printch_res %int_res
    li a1 -1
    beq %int_res a1 printch_res_none
    la a0 ok
    printstr
    mv a0 %int_res
    call print_dec_result
    li a0, ')'
    printch
    j printch_res_end
printch_res_none:
    la a0 none
    printstr
printch_res_end:
.end_macro

.macro FUNC %foo %name
    .data
    name: .asciz %name
    .text
    la s0 strchr
    la s1 name
    la a0 begining1
    printstr
    la a0 name
    printstr
    la a0 begining2
    printstr
.end_macro

.macro OK %res %line %char
    .data
    line: .asciz %line
    .text
    la a0 line
    li a1 %char
    jalr s0 0

    la t0 line
    li t3 %res
    beq a0 zero none

    sub t2 a0 t0
    bne t2 t3 failed

    addi s2 s2 1
    j end
    failed:
    addi s3 s3 1

    li t1 %char
    printch_failed_msg t0 t1 t2 t3

    j end
    none:
    addi s3 s3 1

    li t1 %char
    li t2 -1
    printch_failed_msg t0 t1 t2 t3
    end:
.end_macro

.macro NONE %line %char
    .data
    line: .asciz %line
    .text
    la a0 line
    li a1 %char
    jalr s0 0

    bne a0 zero failed

    addi s2 s2 1

    j end
    failed:
    addi s3 s3 1

    la t0 line
    li t1 %char
    sub t2 a0 t0
    li t3 -1
    printch_failed_msg t0 t1 t2 t3
    end:
.end_macro

.macro DONE 
    .data
    done_start: .asciz "Passed: "
    done_mid: .asciz ", failed: "
    .text
    la a0 done_start
    printstr
    mv a0 s2
    call print_dec_result
    la a0 done_mid
    printstr
    mv a0 s3
    call print_dec_result
    exit(0)
.end_macro