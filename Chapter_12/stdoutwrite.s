.globl main

.section .data
formatstring1:
  .ascii "The age of %s is %d.\n\0"
sallyname:
  .ascii "Sally\0"
sallyage:
  .quad 53
formatstring2:
  .ascii "%d and %d are %s's favorite numbers.\n\0"
joshname:
  .ascii "Josh\0"
joshfavoritefirst:
  .quad 7
joshfavoritesecond:
  .quad 13

.section .text
main:
  # No local variables, no stack frame needed

  # Write the first string to stdout. Important: We do movq stdout instead of
  # movq $stdout. This is because stdout is itself a pointer to the memory
  # location where the file pointer lives, not the pointer itself.
  movq stdout, %rdi
  movq $formatstring1, %rsi
  movq $sallyname, %rdx
  movq sallyage, %rcx
  movq $0, %rax
  call fprintf

  # Write the second string
  movq stdout, %rdi
  movq $formatstring2, %rsi
  movq joshfavoritefirst, %rdx
  movq joshfavoritesecond, %rcx
  movq $joshname, %r8
  movq $0, %rax
  call fprintf

  # Return
  movq $0, %rax
  ret
