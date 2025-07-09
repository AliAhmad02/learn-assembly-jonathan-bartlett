.globl _start
.section .text

_start:
  # Number of times to loop in counter register
  movq $4000000000, %rcx
  # Takes around 1 second for 4 billion loops

mainloop:
  loopq mainloop

complete:
  movq $60, %rax
  syscall
