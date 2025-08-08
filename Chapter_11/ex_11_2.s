.globl _start

.section .data
mynumber:
  .quad 10
string1:
  .ascii "The number was even.\n"
string2:
  .ascii "The number was odd.\n"
strings_end:
  .equ string1_length, string2 - string1
  .equ string2_length, strings_end - string2

.section .text
# We need 2 arguments: pointer to string and string length, which will be in
# %rdi and %rsi
print_string_to_std_out:
  # We need 2 variables on the stack, so we reserve 16 bytes
  enter $16, $0
  # Move our function arguments onto the stack
  movq %rdi, -8(%rbp)
  movq %rsi, -16(%rbp)
  # Perform the syscall
  movq $1, %rax
  movq $1, %rdi
  movq -8(%rbp), %rsi
  movq -16(%rbp), %rdx
  syscall
  # Let the function return 0
  movq $0, %rax
  leave
  ret
  
_start:
  # Perform division of mynumber by 2
  movq mynumber, %rax
  movq $2, %rbx
  movq $0, %rdx
  divq %rbx

  # Check if the remainder is zero
  cmp $0, %rdx
  jne set_odd_args

set_even_args:
  # Prepare function arguments for even case
  movq $string1, %rdi
  movq $string1_length, %rsi
  jmp finish

set_odd_args:
  # Prepare function arguments for even case
  movq $string2, %rdi
  movq $string2_length, %rsi

finish:
  # Call the function to print the string
  call print_string_to_std_out
  # Exit
  movq $0, %rdi
  movq $60, %rax
  syscall
