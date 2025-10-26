.globl main, QUAD_SIZE

.section .data

.equ QUAD_SIZE, 8

array:
  .quad 1, 2, 3, 4, 5, 6
array_end:

array_length:
  .quad (array_end - array)/QUAD_SIZE

format_string:
  .ascii "%d\0\n"

.section .text

main:
  enter $0, $0
  movq array, %rdi
  movq array_length, %rsi
  movq $0, %rax
  call array_sum

  movq stdout, %rdi
  movq $format_string, %rsi
  movq %rax, %rdx
  movq $0, %rax
  call fprintf

  # Return 0 (success)
  movq $0, %rax
  leave
  ret
  

# Parameters: array in %rdi and array_length in %rsi
array_sum:
  enter $0, $0
  # We move the first value in the array (index 0) into %rax
  movq %rdi, %rax
  # We move the length of the array into %rcx
  movq %rsi, %rcx
  # Because we already have the first value in the sum, we want to skip it
  # when we do the loop, so we decrement our counter in %rcx. The nice thing
  # here is that now, we do not need a separate pointer into the array, the
  # counter itself can be used to fetch the array elements
  decq %rcx

continue:
  addq array(,%rcx,8), %rax
  loopq continue
  
finish:
  leave
  ret

