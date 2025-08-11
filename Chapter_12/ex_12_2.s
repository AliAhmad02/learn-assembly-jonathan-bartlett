.globl main

.section .data
scanformat:
  .ascii "%ld %ld\0"

resultformat1:
  .ascii "%ld is larger than %ld.\n\0"

resultformat2:
  .ascii "The numbers %ld and %ld are equal.\n\0"

.section .text
.equ FILE_POINTER, -8
.equ FIRST_NUM, -16
.equ SECOND_NUM, -24

file1:
  .ascii "read_input.txt\0"

file2:
  .ascii "write_output.txt\0"

openmode1:
  .ascii "r\0"

openmode2:
  .ascii "w\0"
# This function returns a pointer to the format string to be used to print the
# result of the comparison. Also, if num2>num1, it swaps the values in the
# two registers. This means that %rdi will always hold the larger value and
# %rsi the smaller value. Of course, if they are equal, the order doesn't
# matter anyway
compare_nums:
  cmpq %rsi, %rdi
  je set_format2
  movq $resultformat1, %rax
  ja finish

swap:
  xchgq %rsi, %rdi
  jmp finish

set_format2:
  movq $resultformat2, %rax

finish:
  ret

  
main:
  # Allocate space for three local variables + 16-byte alignment (variables
  # are the file pointer and two integers)
  enter $32, $0

  # Open the first file for reading
  movq $file1, %rdi
  movq $openmode1, %rsi
  call fopen

  # Save the file pointer in the local variable
  movq %rax, FILE_POINTER(%rbp)

  # Read the data from the file and get it into two local variables
  movq FILE_POINTER(%rbp), %rdi
  movq $scanformat, %rsi
  leaq FIRST_NUM(%rbp), %rdx
  leaq SECOND_NUM(%rbp), %rcx
  movq $0, %rax
  call fscanf

  # Close the first file
  movq FILE_POINTER(%rbp), %rdi
  call fclose

  # Open the second file for writing
  movq $file2, %rdi
  movq $openmode2, %rsi
  call fopen

  # Save the file pointer in the local variable
  movq %rax, FILE_POINTER(%rbp)

  # Use comparison function
  movq FIRST_NUM(%rbp), %rdi
  movq SECOND_NUM(%rbp), %rsi
  call compare_nums

  # Moving %rdi and %rsi into %rdx and %rcx (varargs for fprintf). We need to
  # do this first because we have to use %rdi and %rsi to pass other arguments
  movq %rdi, %rdx
  movq %rsi, %rcx
  # Moving file pointer into %rdi
  movq FILE_POINTER(%rbp), %rdi
  # Moving pointer to resultformat into %rsi
  movq %rax, %rsi
  # Zeroing %rax and calling fprintf
  movq $0, %rax
  call fprintf
  leave
  ret
