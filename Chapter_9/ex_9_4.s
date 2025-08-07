.globl _start
.section .text

_start:
  # Load the three values into registers
  movb $0b11111111, %al
  movb $0b01101101, %cl
  movb $0b10110100, %dil

  andb %al, %cl
  andb %cl, %dil

  movq $60, %rax
  syscall

