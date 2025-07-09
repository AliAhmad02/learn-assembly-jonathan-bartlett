.globl _start
.section .text

_start:
  # The number that we want to check for even/odd
  movq $255, %rcx

  # If it is zero, we say that it is even (thus %rax is zero, i.e. we do nothing)
  cmpq $0, %rcx
  je complete

odd:
  movq $1, %rax
  loopq even
  # We have to add this to prevent an infinite loop
  jmp complete

even:
  movq $0, %rax
  loopq odd

complete:
  movq %rax, %rdi
  movq $60, %rax
  syscall

