.globl factorial
.section .text

factorial:
  # We will reserve space for 1 variable plus another 8 bytes for alignment
  enter $16, $0

  # If the argument is 1, we return 1
  cmpq $1, %rdi
  jne continue

  # Return 1
  movq $1, %rax
  leave
  ret

continue:
  # Save the argument into our stack storage
  movq %rdi, -8(%rbp)

  # Call factorial with %rdi decreased by 1
  decq %rdi
  call factorial

  # The result will be in %rax. Multiply the result by our first argument
  # that we stored on the stack
  mulq -8(%rbp)
  # Result is in %rax, which is what is needed for the return value
  leave
  ret
