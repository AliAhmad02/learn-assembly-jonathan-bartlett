.globl _start
.section .data

arraylength:
  .quad 7

array:
  .quad 5, 20, 33, 80, 52, 10, 1

.section .text

_start:
  # Put the array length into %rcx
  movq arraylength, %rcx

  # If the array is empty, we are done
  cmp $0, %rcx
  je endloop

  # Otherwise, put the first array element (the min value so far) into %rdi
  movq array, %rdi

  myloop:
    # Put the value indexed by %rcx into %rax
    # Here, we should remember that last index=length-1. So we must subtract
    # 8 bytes from the address: adress= mynumbers + 0 + %rcx * 8 - 8
    movq array-8(,%rcx,8), %rax

    # If it is not smaller than current min, go to end of loop
    cmp %rdi, %rax
    jae loopcontrol

    # Otherwise, update the min
    movq %rax, %rdi

  loopcontrol:
    # Decrement %rcx and keep going until %rcx is zero
    loopq myloop

  endloop:
    movq $60, %rax
    syscall
