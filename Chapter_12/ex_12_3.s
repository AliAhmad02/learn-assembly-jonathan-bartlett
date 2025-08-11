.globl main

.section .data
promptformat:
  .ascii "Enter two numbers separated by spaces, then press enter.\n\0"

scanformat:
  .ascii "%ld %ld\0"

resultformat1:
  .ascii "%ld is larger than %ld.\n\0"

resultformat2:
  .ascii "The numbers %ld and %ld are equal.\n\0"

.section .text
.equ FIRST_NUM, -8
.equ SECOND_NUM, -16

# This function returns a pointer to the format string to be used to print the
# result of the comparison. Also, if num2<num1, it swaps the values in the
# two registers. This means that %rdi will always hold the larger value and
# %rsi the smaller value. Of course, if they are equal, the order doesn't
# matter anyway
compare_nums:
  cmpq %rsi, %rdi
  je set_format2
  movq $resultformat1, %rax
  ja finish

swap:
  xchgq %rsi, %rdi
  jmp finish

set_format2:
  movq $resultformat2, %rax

finish:
  ret

  
main:
  # Allocate space for two local variables
  enter $16, $0

  # Show the prompt to stdout
  movq stdout, %rdi
  movq $promptformat, %rsi
  # Setting %rax to zero, since fprintf is a variadic function
  movq $0, %rax
  call fprintf

  # Get the data into the two local variables
  movq stdin, %rdi
  movq $scanformat, %rsi
  leaq FIRST_NUM(%rbp), %rdx
  leaq SECOND_NUM(%rbp), %rcx
  movq $0, %rax
  call fscanf

  # Get pointer to correct format string and %rdi and %rsi sorted by size
  movq FIRST_NUM(%rbp), %rdi
  movq SECOND_NUM(%rbp), %rsi
  call compare_nums

  # Moving %rdi and %rsi into %rdx and %rcx (varargs for fprintf). We need to
  # do this first because we have to use %rdi and %rsi to pass other arguments
  movq %rdi, %rdx
  movq %rsi, %rcx
  # Moving stdout to %rdi and the format string pointer into %rsi
  movq stdout, %rdi
  movq %rax, %rsi
  movq $0, %rax
  call fprintf

  leave
  jmp main
