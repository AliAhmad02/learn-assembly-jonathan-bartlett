.globl _start
.section .text

_start:
  # Numbers to be multiplied
  movq $4, %rbx
  movq $5, %rcx

  # If the counter is zero initially, we are done, since we don't want to decrement it after this
  cmpq $0, %rcx
  je complete

mainloop:
  addq %rbx, %rax
  loopq mainloop

complete:
  movq %rax, %rdi
  movq $60, %rax
  syscall
