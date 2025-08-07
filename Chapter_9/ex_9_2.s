.globl _start

.section .data
mystring:
  .ascii "Hello, this is a string\0"

.section .text
_start:
  # Initialize %rcx to largest possible value so we are sure that the counter
  # %rcx is large enough
  movq $-1, %rcx

  movq $mystring, %rdi # Load memory address into %rdi
  movb $0, %al # Load null terminator into %al
  repne scasb # Check if character is null. Repeat as long as not true.

  # Subtract starting address from %rdi
  subq $mystring, %rdi
  
  # The scasb instruction increments %rdi after every time, so after the final
  # comparison, it will be incremented 1 beyond the null terminator. We
  # subtract 1 to get the length
  decq %rdi

  movq $60, %rax
  syscall
