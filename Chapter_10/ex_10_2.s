.globl _start

.section .data
string:
  .ascii "This is string1.\n"
string_end:
  .equ string_length, string_end - string

.section .text
_start:
  # Prepare output writing syscall
  movq $1, %rdi
  movq $string, %rsi
  movq $string_length, %rdx

  # Prepare counter (can't use %rcx because syscall clobbers it)
  movq $10, %rbx

myloop:
  # The syscall number is prepared in the loop, since syscall clobbers %rax 
  movq $1, %rax
  # Perform syscall
  syscall
  # Decrement counter
  decq %rbx
  # Jump back to myloop if zero flag is not set (i.e. the result of the last
  # arithmetic operation (which is the decrement) was not zero
  jnz myloop

finish:
  movq $0, %rdi
  movq $60, %rax
  syscall
