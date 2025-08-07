.globl _start

.section .data
curtime:
  # The time will be stored here
  .quad 0

.section .text
_start:
  # Get the initial time
  movq $0xc9, %rax
  movq $curtime, %rdi
  syscall

  # Store the time in %rdx
  movq curtime, %rdx

  # Add 5 seconds
  addq $5, %rdx

timeloop:
  # Check the current time (and store it in curtime)
  movq $0xc9, %rax
  # In principle, this is unnecessary, the pointer is already in %rdi
  movq $curtime, %rdi
  syscall

  # If we haven't reached the time specified in %rdx, start over
  cmpq %rdx, curtime
  jb timeloop

timefinish:
  # Exit
  movq $0x3c, %rax
  movq $0, %rdi
  syscall
