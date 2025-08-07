.globl _start
.section .text

_start:
  # Initialize value for which to do one-count
  movq $10, %rax

  # Initialize %rcx with number of bits in value
  movq $64, %rcx

  # Initialize bitmask register
  movq $1, %rdx

  # Initialize counting register
  movq $0, %rdi

mainloop:
  # Perform AND with bitmask and value
  testq %rdx, %rax
  
  # If the bit is set, jump to loopcontrol
  jnz loopcontrol

  # Otherwise, go to end of loop
  jmp endloop

loopcontrol:
  # Increment the count by 1
  incq %rdi

endloop:
  # Rotate the bitmask to the right by 1. Remember here: The bits are stored
  # in %rdx in little endian format. Thus, when we initialized the mask to 1
  # (i.e. 0b00...1), how it's actually stored in the register is (0b10...0).
  # Thus, the first right rotation gives us (0b01...0) as actually stored
  # in the register. However, the actual value is 0b00...10. Doesn't matter
  # much here, but worth keeping in mind
  rorq $1, %rdx

  # Increment %rcx and go back to mainloop
  loopq mainloop

finish:
  movq $60, %rax
  syscall
