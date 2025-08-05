.globl _start

.section .data
mytext:
  .ascii "This is a string of characters.\0"

.section .text
_start:
  # Move a pointer to the string into %rbx
  movq $mytext, %rbx

  # Start count at zero
  movq $0, %rdi

mainloop:
  # Get the next byte. () indicates direct memory mode, i.e. we are reffering
  # to a value by its memory address. That is, %rbx holds a memory address to
  # the string. direct memory mode means that we take that memory address and
  # look up the corresponding value in the memory.
  movb (%rbx), %al

  # Quit if we hit the null terminator
  cmpb $0, %al
  je finish
  
  # Increment counter
  incq %rdi

  # Next byte
  incq %rbx

  # Repeat
  jmp mainloop

finish:
  movq $60, %rax
  syscall
