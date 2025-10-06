# Rewriting exercise 12.4 to be position-independent
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

retryprompt:
  .ascii "Press 1 to try again or any other number to finish.\n\0"

scanretry:
  .ascii "%ld\0"

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
  leaq resultformat1(%rip), %rax
  ja finish

swap:
  xchgq %rsi, %rdi
  jmp finish

set_format2:
  leaq resultformat2(%rip), %rax

finish:
  ret
 
main:
  # Allocate space for two local variables
  enter $16, $0

  # Show the prompt to stdout
  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq promptformat(%rip), %rsi
  # Setting %rax to zero, since fprintf is a variadic function
  movq $0, %rax
  call fprintf@plt

  # Get the data into the two local variables
  movq stdin@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq scanformat(%rip), %rsi
  leaq FIRST_NUM(%rbp), %rdx
  leaq SECOND_NUM(%rbp), %rcx
  movq $0, %rax
  call fscanf@plt

  # Get pointer to correct format string and %rdi and %rsi sorted by size
  movq FIRST_NUM(%rbp), %rdi
  movq SECOND_NUM(%rbp), %rsi
  call compare_nums

  # Moving %rdi and %rsi into %rdx and %rcx (varargs for fprintf). We need to
  # do this first because we have to use %rdi and %rsi to pass other args
  movq %rdi, %rdx
  movq %rsi, %rcx
  # Moving stdout to %rdi and the format string pointer into %rsi
  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  movq %rax, %rsi
  movq $0, %rax
  call fprintf@plt

  # Show the retry prompt to stdout
  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq retryprompt(%rip), %rsi
  # Setting %rax to zero, since fprintf is a variadic function
  movq $0, %rax
  call fprintf@plt

  # Get the user input for retrying into the FIRST_NUM(%rbp) variable
  movq stdin@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq scanretry(%rip), %rsi
  leaq FIRST_NUM(%rbp), %rdx
  movq $0, %rax
  call fscanf@plt

  # Move the user input into %rcx for comparison and destroy stack frame
  movq FIRST_NUM(%rbp), %rcx
  leave
 
  # Check if the user input was 1. If it was, retry. Otherwise, we're done
  cmpq $1, %rcx 
  je main

  ret
