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

.macro push %r1
	addi sp, sp, -4
	sw %r1, 0(sp)
.end_macro

.macro pop %r1
	lw %r1, 0(sp)
	addi sp, sp, 4
.end_macro

.macro push2 %r1 %r2
	addi sp, sp, -8
	sw %r1, 0(sp)
	sw %r2, 4(sp)
.end_macro

.macro pop2 %r1 %r2
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	addi sp, sp, 8
.end_macro

.macro push3 %r1 %r2 %r3
	addi sp, sp, -12
	sw %r1, 0(sp)
	sw %r2, 4(sp)
	sw %r3, 8(sp)
.end_macro

.macro pop3 %r1 %r2 %r3
	lw %r1, 0(sp)
	lw %r2, 4(sp)
	lw %r3, 8(sp)
	addi sp, sp, 12
.end_macro


.macro swap %r1, %r2
	xor %r1, %r1, %r2
	xor %r2, %r2, %r1
	xor %r1, %r1, %r2
.end_macro