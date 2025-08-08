.globl _start
.globl exponent_factorial_print
.type exponent_factorial_print, @function
.section .text

# Function that takes 1 parameter in %rdi
exponent_factorial_print:
  # Reserve 16 bytes (8 for value, another 8 for alignment)
  enter $16, $0
  movq %rdi, -8(%rbp)
  
  # Perform division of function parameter by 2 and check if remainder is zero
  movq %rdi, %rax
  movq $2, %rcx
  divq %rcx
  cmp $0, %rdx
  jne odd
  
even:
  call factorial
  leave
  ret

odd:
  movq $3, %rsi
  call exponent
  leave
  ret

_start:
  movq $3, %rdi
  call exponent_factorial_print
  movq %rax, %rdi
  movq $60, %rax
  syscall
