.section .text
.globl _start
_start:
   movq $0b1001, %rdi
   movq $60, %rax
   syscall
