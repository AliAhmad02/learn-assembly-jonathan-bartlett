.globl _start

.section .data
string1:
  .ascii "This is string1.\n"
string2:
  .ascii "This is string2.\n"
string_end:
  .equ string1_length, string2 - string1
  .equ string2_length, string_end - string2

.section .text
_start:
  # Prepare output writing syscall
  movq $1, %rdi

  # Prepare counter (can't use %rcx because syscall clobbers it)
  movq $10, %rbx

myloop:
  # Perform division of %rbx by 2
  movq %rbx, %rax
  movq $2, %rcx
  movq $0, %rdx
  divq %rcx

  # Print string1 or string2 according to even/odd
  cmp $0, %rdx
  jne print_string2

print_string1:
  # Prepare output writing syscall
  movq $1, %rax
  movq $string1, %rsi
  movq $string1_length, %rdx
  jmp endloop

print_string2:
  # Prepare output writing syscall
  movq $1, %rax
  movq $string2, %rsi
  movq $string2_length, %rdx

endloop:
  # Perform write syscall
  syscall
  # Loop
  decq %rbx
  jnz myloop
  
finish:
  movq $0, %rdi
  movq $60, %rax
  syscall
