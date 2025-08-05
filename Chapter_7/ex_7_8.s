.globl _start
.section .text

_start:
  # Move pointer to the first name into %rbx
  leaq people, %rbx

  # Store length of longest name
  movq $0, %rdi

  # Store number of records in %rcx
  movq numpeople, %rcx

  # Store counter for current string into %rdx
  movq $0, %rdx

  # If there are no records, we are done
  cmpq $0, %rcx
  je finish

mainloop:
  # Get the next byte
  movb (%rbx), %al

  # If we hit the null terminator, go to endloop
  cmpb $0, %al
  je endloop

  # Otherwise, increment %rdx
  incq %rdx

loopcontrol:
  # Get the next byte
  incq %rbx

  # Repeat mainloop
  jmp mainloop

endloop:
  # If the current count is larger than the max, update the max count
  cmp %rdx, %rdi
  cmovb %rdx, %rdi
  
  # Reset length counter
  movq $0, %rdx

  # Go to next person
  addq $PERSON_RECORD_SIZE, %rbx
  loopq mainloop

finish:
  movq $60, %rax
  syscall
