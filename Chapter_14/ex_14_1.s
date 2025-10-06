.globl main
.section .data

scanformat:
  .ascii "%d\0"

printformat:
  .ascii "%d\n\0"

printformat_a:
  .ascii "%s\0"

.section .text
.equ LOCAL_VAR1, -8
.equ LOCAL_VAR2, -16

main:
  # Two local variables, allocation size and pointer to location
  enter $16, $0

  # Get allocation size input
  movq stdin, %rdi
  movq $scanformat, %rsi
  leaq LOCAL_VAR1(%rbp), %rdx
  movq $0, %rax
  call fscanf

  # Allocate the memory
  movq LOCAL_VAR1(%rbp), %rdi
  call allocate
  movq %rax, LOCAL_VAR2(%rbp)

  # Print the memory adress
  movq stdout, %rdi
  movq $printformat, %rsi 
  movq LOCAL_VAR2(%rbp), %rdx 
  call fprintf

  # Fill allocated memory with the letter a
  movq LOCAL_VAR2(%rbp), %rdi
  movq %rdi, %rsi
  addq LOCAL_VAR1(%rbp), %rsi
  call generate_a

  # Print the string of as
  movq stdout, %rdi
  movq $printformat_a, %rsi
  movq LOCAL_VAR2(%rbp), %rdx
  call fprintf

  # Free the memory
  movq LOCAL_VAR2(%rbp), %rdi
  call deallocate

  movq $0, %rax

  leave
  ret

generate_a:
  # Move a into the location specified by the pointer stored in %rdi
  movq $'a' , (%rdi)
  # Increment %rdi
  incq %rdi
  # If %rdi is not equal to the memory location in %rsi (final location) then
  # jump back to generate_a
  cmpq %rsi, %rdi
  jne generate_a
  ret
