.globl printstuff

.section .data
mytext:
  .ascii "hello there\n\0"

.section .text
printstuff:
  enter $0, $0
  # Look up the location of stdout in the GOT using PC-relative addressing
  movq stdout@GOTPCREL(%rip), %rdi
  # Then, use the address of stdout to actually load stdout
  movq (%rdi), %rdi
  leaq mytext(%rip), %rsi
  call fprintf@plt

  leave
  ret
