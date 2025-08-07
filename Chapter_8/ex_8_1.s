.globl _start
.section .text

_start:
  movb $0b00000001, %al
  addb $0b11111111, %al
  jo overflow

no_overflow:
  movq $0, %rdi
  jmp finish

overflow:
  movq $1, %rdi

finish:
  movq $60, %rax
  syscall
