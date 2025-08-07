.globl _start

.section .data

arraylength:
  .quad 10

array:
  .quad 10, 3, 4, 91, 10, 30, 4, 9, 10, 133

.section .text

_start:
  # Load address of array into %rdi
  leaq array, %rdi

  # Load value to be searched for into %rax
  movq $30, %rax

  # Load arraylength into counter
  movq arraylength, %rcx

  # Compare each value in array to %rax. Keep going while comparison is false
  repne scasq

  # Calculate array index from %rcx. Since %rcx is decremented at the end,
  # we need to subtract 1 to get the index. I.e., it's arraylength-%rcx-1.
  movq arraylength, %rdi
  subq %rcx, %rdi
  decq %rdi

  movq $60, %rax
  syscall
