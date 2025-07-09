.globl _start

.section .text

_start:
  movq $2, %rbx

  movq $7, %rcx

  movq $1, %rax

  # Compare 0 to the exponent
  cmpq $0, %rcx

  # If exponent is 0, we are done
  je complete

mainloop:
  mulq %rbx

  # Decrement %rcx (counter register), jump to mainloop if %rcx!=0
  loopq mainloop

complete:
  movq %rax, %rdi

  movq $60, %rax

  syscall
