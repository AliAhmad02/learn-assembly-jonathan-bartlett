.globl _start

.section .data

arraylength:
  .quad 10

array:
  .quad 2, 4, 9, 39, 20, 0, 3, 5, 6, 67

.section .text

_start:
  # Initialize value we are searching for
  movq $39, %rbx

  # Initialize whether or not the value has been found
  movq $0, %rdi

 # Put the number of elements in the array into %rcx
 movq arraylength, %rcx

 # If the array is empty, we are done
 cmp $0, %rcx
 je endloop

loop:
  # Get the value in the array indexed by %rcx
  movq array-8(,%rcx,8), %rax

  # If it is the value that we are looking for, update %rdi, otherwise, jump
  cmp %rbx, %rax
  jne loopcontrol
  movq $1, %rdi

loopcontrol:
  loopq loop
  
endloop:
  movq $60, %rax
  syscall
