.globl _start

.section .data
mynumber:
  .quad 11
string1:
  .ascii "The number was even.\n"
string2:
  .ascii "The number was odd.\n"
strings_end:
  .equ string1_length, string2 - string1
  .equ string2_length, strings_end - string2

.section .text
_start:
  # Perform division of mynumber by 2
  movq mynumber, %rax
  movq $2, %rbx
  movq $0, %rdx
  divq %rbx

  # Prepare syscall number and file descriptor
  movq $1, %rax
  movq $1, %rdi

  # Print string1 or string2 according to even/odd
  cmp $0, %rdx
  jne print_string2

print_string1:
  movq $string1, %rsi
  movq $string1_length, %rdx
  jmp finish

print_string2:
  movq $string2, %rsi
  movq $string2_length, %rdx

finish:
  syscall
  movq $0, %rdi
  movq $60, %rax
  syscall
