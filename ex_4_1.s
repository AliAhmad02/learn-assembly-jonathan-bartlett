.globl _start
.section .text
_start:
   # We are changing rdi->rcx and rax->rdx compared to arithmetic.s
   movq $3, %rcx
   movq %rcx, %rdx
   addq %rcx, %rdx
   # Because we do a mul, we go back to using rax in place of rdx
   movq %rdx, %rax
   mulq %rcx
   movq $2, %rcx
   addq %rcx, %rax
   movq $4, %rcx
   mulq %rcx
   movq %rax, %rcx

   movq $60, %rax
   # We also need to go back to rcx->rdi because the syscall needs it in rdi
   movq %rcx, %rdi
   
   syscall
