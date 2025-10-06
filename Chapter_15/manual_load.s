.globl main

.section .data
filename:
  .ascii "libmymath.so\0"

functionname:
  .ascii "printstuff\0"

.section .text
main:
  enter $0, $0

  # dlopen function to load libmymath.so maunally
  movq $filename, %rdi
  movq $1, %rsi
  call dlopen

  # dlsym searches for the symbol "printstuff" in libmymath.so and returns a
  # pointer to the function
  movq %rax, %rdi
  movq $functionname, %rsi
  call dlsym

  # We now call the function that the pointer points to (hence *)
  call *%rax

  leave
  ret
