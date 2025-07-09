.globl _start
.section .text

_start:
  movq $10, %rax
  jmp there

here:
  addq %rbx, %rax
  jmp somewhere

there:
  movq $5, %rbx
  jmp here

anywhere:
  movq $60, %rax
  syscall

somewhere:
  movq %rax, %rdi
  jmp anywhere
