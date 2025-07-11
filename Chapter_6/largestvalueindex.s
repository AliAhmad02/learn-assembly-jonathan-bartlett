.globl _start

.section .data

arraylength:
  .quad 7

array:
  .quad 5, 20, 33, 80, 52, 10, 1

.section .text

_start:
  # Number of array elements moved into %rcx
  movq arraylength, %rcx

  # Put index of the first element in %rbx
  movq $0, %rbx

  # Use %rdi to hold the current high-value
  movq $0, %rdi

  # If the array is empty, skip to the end
  cmp $0, %rcx
  je endloop

myloop:
  # Get the next value of the array at the index of %rbx
  # Formula: array + 0 + %rbx * 8
  movq array(,%rbx,8), %rax

  # If it is not bigger than current max, jump to the end of the loop
  cmp %rdi, %rax
  jbe loopcontrol

  # Otherwise, update the max value
  movq %rax, %rdi

loopcontrol:
  # Move %rbx to the next index
  incq %rbx

  # Decrement %rcx and keep going until %rcx is zero
  loopq myloop

endloop:
  movq $60, %rax
  syscall
