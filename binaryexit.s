.section .text
.globl _start
_start:
   movq $0b11111111, %rdi
   movq $60, %rax
   syscall
