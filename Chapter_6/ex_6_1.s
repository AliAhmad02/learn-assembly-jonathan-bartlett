# Main idea here: We count down from the end of the array to the start
# This makes it so that %rcx serves both as the length and as the index
# All in all, this saves us two instructions, making the program faster
.globl _start
.section .data

arraylength:
  .quad 15

array:
  .quad 5, 20, 33, 80, 52, 10, 1, 10, 5, 20, 5, 90, 12, 45, 8

.section .text

_start:
  # Put the array length into %rcx
  movq arraylength, %rcx

  # Use %rdi to hold the current max value
  movq $0, %rdi

  # If the array is empty, we are done
  cmp $0, %rcx
  je endloop

  myloop:
    # Put the value indexed by %rcx into %rax
    # Here, we should remember that last index=length-1. So we must subtract
    # 8 bytes from the address: adress= mynumbers + 0 + %rcx * 8 - 8
    movq array-8(,%rcx,8), %rax

    # If it is not bigger than current max, go to end of loop
    cmp %rdi, %rax
    jbe loopcontrol

    # Otherwise, update the maxxx
    movq %rax, %rdi

  loopcontrol:
    # Decrement %rcx and keep going until %rcx is zero
    loopq myloop

  endloop:
    movq $60, %rax
    syscall
