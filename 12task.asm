.include "macro.asm"
.include "forfiles.asm"
.include "operations.asm"

.text
.global main
main:
    lw a0 0(a1)  # file name
    li a1 0      # read flag
    openfile
    mv s0 a0
    call loadfile
    call countlines
    call print_dec_result
    mv a0 s0
    closefile
    exit 0