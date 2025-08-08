.globl factorial
.section .text

# This is the offset into the stack frame (%rbp) that we store the number for
# which we are taking the factorial
.equ LOCAL_NUM, -8

factorial:
  # We reserve space for 1 variable 8 bytes and another 8 bytes for alignment
  enter $16, $0

  # If the argument is 1, then return the result as 1
  # Otherwise, continue on
  cmpq $1, %rdi
  jne continue

  # Return 1
  movq $1, %rax
  leave
  ret

continue:
  # Save the argument into our stack storage
  movq %rdi, LOCAL_NUM(%rbp)
  # Call factorial with %rdi decremented
  decq %rdi
  call factorial

  # The result will be in %rax. Multiply the result by our first argument we
  # stored on the stack
  mulq LOCAL_NUM(%rbp)
  # Result is in %rax, which is what is needed for the return value
  leave
  ret
