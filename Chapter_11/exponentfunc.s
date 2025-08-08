.globl exponent
.type exponent, @function

.section .text
exponent:
  # %rdi has the base and %rsi has the exponent
  
  # We create the stack frame with one 8-byte local variable. We refer to this
  # using -8(%rbp). This will store the current value of the exponent as we
  # iterate through it. Even though we only need 8 bytes, we will allocate 16,
  # in order to maintain 16 byte alignment
  enter $16, $0

  # Accumulated value in %rax
  movq $1, %rax

  # Store the exponent as a local stack variable
  movq %rsi, -8(%rbp)

mainloop:
  mulq %rdi
  # Decrement the local variable for the exponent
  decq -8(%rbp)
  # If the local variable is not zero after decrementing, repeat
  jnz mainloop

complete:
  # Result (return value) is already in %rax, so no need to do anything there
  leave
  ret
