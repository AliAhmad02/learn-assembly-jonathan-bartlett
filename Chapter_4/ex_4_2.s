.section .text
.globl _start
_start:
   movq $5, %rax
   movq %rax, %rdi
   addq %rax, %rdi
   mulq %rdi
   divq %rdi
   
   movq %rax, %rdi
   movq $60, %rax
   syscall
