# Because the length is too long, we end up attempting to access a bunch of
# memory addresses outside your program, resulting in a segmentation fault:
# [1]    1226454 segmentation fault (core dumped)  ./ex_6_3
.globl _start
.section .data

arraylength:
  .quad 1100

array:
  .quad 5, 20, 33, 80, 52, 10, 1

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
