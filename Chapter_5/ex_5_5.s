.globl _start
.section .text

_start:
  # The number for which we want to check if it is even/odd
  movq $7, %rax

  movq $2, %rbx
  
  divq %rbx

  movq %rdx, %rdi
  movq $60, %rax
  syscall


