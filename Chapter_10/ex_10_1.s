.globl _start

.section .data
string1:
  .ascii "This is string1.\n"
string2:
  .ascii "This is string2.\n"
string2_end:
  .equ string1_length, string2 - string1
  .equ string2_length, string2_end - string2

.section .text
_start:
  # Output syscall
  movq $1, %rax
  # File descriptor (standard output)
  movq $1, %rdi
  # Pointer to the first string
  movq $string1, %rsi
  # Length of the first string
  movq $string1_length, %rdx
  syscall

  # Need to reinitialize %rax again, since it contains the return value
  movq $1, %rax
  movq $string2, %rsi
  movq $string2_length, %rdx
  syscall

  movq $0, %rdi
  movq $60, %rax
  syscall
