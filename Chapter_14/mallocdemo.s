.globl main

.section .data
scanformat:
  # This format means that the string can, at most, be 499 characters long.
  # This is important because the %s format just reads a string with no limits
  # on how long it can be. Thus, the user can enter characters beyond the
  # buffer size and trigger a buffer overflow. Thus, we limit it to 499
  # characters, where 500th character is reserved for a null terminator
  .ascii "%499s\0"

outformat:
  .ascii "%s\n\0"

.section .text
.equ LOCAL_BUFFER, -8
main:
  # Allocate one local variable on the stack (aligned to 16 bytes)
  enter $16, $0

  # Get the memory adress and store it in our local variable
  movq $500, %rdi
  call malloc
  movq %rax, LOCAL_BUFFER(%rbp)

  movq $5, (%rax)
  
  # Read the data from stdin
  movq stdin, %rdi
  movq $scanformat, %rsi
  movq LOCAL_BUFFER(%rbp), %rdx
  movq $0, %rax
  call fscanf

  # Write the data to stdout
  movq stdout, %rdi
  movq $outformat, %rsi
  movq LOCAL_BUFFER(%rbp), %rdx
  movq $0, %rax
  call fprintf

  # Free the buffer
  movq LOCAL_BUFFER(%rbp), %rdi
  call free

  # Return
  movq $0, %rax
  leave
  ret
