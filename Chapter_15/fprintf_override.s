.globl fprintf

.section .data
mytext:
  .ascii "Haha! I intercepted you!\n"
mytextend:

.section .text
fprintf:
  # Syscall to replace fprintf
  movq $1, %rax
  movq $1, %rdi
  # Load mytext into %rsi using PC-relative addressing
  leaq mytext(%rip), %rsi
  # Move size of text into %rdx
  movq $(mytextend - mytext), %rdx
  syscall
  ret
