.globl _start

.section .text

_start:
  movq $7, %rdi
  jmp nextplace

  # This instruction is skipped, verify by checking status code
  movq $8, %rdi

nextplace:
  movq $60, %rax
  syscall
