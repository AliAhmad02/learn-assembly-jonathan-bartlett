.globl main


.section .data
promptformat:
  .ascii "Enter a number below:\n\0"

scanformat:
  .ascii "%ld\0"

resultformat:
  .ascii "The factorial of %ld is %ld.\n\0"

.section .text

.equ FIRST_NUM, -8
.equ SECOND_NUM, -16

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

  # Get the data into the first local variable
  movq stdin@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq scanformat(%rip), %rsi
  leaq FIRST_NUM(%rbp), %rdx
  movq $0, %rax
  call fscanf@plt

  # Call the factorial function and move the result into SECOND_NUM
  movq FIRST_NUM(%rbp), %rdi
  call factorial@plt
  movq %rax, SECOND_NUM(%rbp)
 
  # Moving stdout to %rdi and the format string pointer into %rsi
  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq resultformat(%rip), %rsi
  # Moving the varargs for fprintf into the correct registers
  movq FIRST_NUM(%rbp), %rdx
  movq SECOND_NUM(%rbp), %rcx
  movq $0, %rax
  call fprintf@plt

  leave
  ret
