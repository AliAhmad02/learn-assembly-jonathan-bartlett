.globl _start

.section .data

arraylength:
  .quad 7

array:
  .quad 5, 20, 33, 80, 52, 10, 1

.section .text
_start:
  # Put length of array into %rcx
  movq arraylength, %rcx

  # Put *address* of the first element into %rbx
  movq $array, %rbx

  # Use %rdi to hold the current highest value
  movq $0, %rdi

  # If the array is empty, then we are done
  cmp $0, %rcx
  je endloop

myloop:
  # Get the next value (%rbx contains the *memory address* for the value)
  movq (%rbx), %rax

  # If this value is not larger than the current max in %rdi, jump
  cmp %rdi, %rax
  jbe loopcontrol

  # Otherwise, update the max value
  movq %rax, %rdi

loopcontrol:
  # Change the address in %rbx to point to the next value (add 1 byte)
  addq $8, %rbx

  # Decrement %rcx and keep going until %rcx is zero
  loopq myloop

endloop:
  movq $60, %rax
  syscall
  
