.globl _start
.section .text

_start:
  # Load number into %rax
  movq $100, %rax

  # Load zero into %rdi
  movq $0, %rdi
  
  # Perform AND with fifth bit
  testq $0b100000, %rax
  jnz bitwasset
  jmp finish

bitwasset:
  movq $1, %rdi

finish:
  movq $60, %rax
  syscall
