.globl _start

.section .text

_start:
  # Initialize the base
  movq $2, %rbx

  # Intialize the exponent
  movq $3, %rcx

  # Initialize accumulator (stores intermediate and final value)
  movq $1, %rax

mainloop:
  # Adding zero will allow us to use the flags to determine if %rcx (the exponent) is zero
  addq $0, %rcx

  # If exponent=0, we are done
  jz complete

  # Otherwise mutiply %rax (initialized to 1) by the base, %rbx
  mulq %rbx

  # Decrease exponent by 1
  decq %rcx

  # Unconditional jump, will keep going until the conditional jump is triggered by exponent=0
  jmp mainloop

complete:
  # Move the accumulated value to %rdi so it can be returned
  movq %rax, %rdi

  # Perform "exit" syscall
  movq $60, %rax
  syscall
