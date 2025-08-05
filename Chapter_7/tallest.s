.globl _start
.section .text

_start:
  # leaq: Load effective memory address, loads memory address, not content
  # Pointer to first record
  leaq people, %rbx

  # Record count
  movq numpeople, %rcx

  # Tallest value found
  movq $0, %rdi
  
  # If there are no records, we are done
  cmpq $0, %rcx
  je finish

mainloop:
  # %rbx holds the pointer (memory address) to first record. Thus, we can grab
  # the height by adding the height offset to the address in %rbx.
  movq HEIGHT_OFFSET(%rbx), %rax

  # If it is less than or equal to current tallest, go to next height
  cmpq %rdi, %rax
  jbe endloop

  # Otherwise, update tallest height
  movq %rax, %rdi

endloop:
  # Move %rbx to point to the next record
  addq $PERSON_RECORD_SIZE, %rbx

  # Decrement %rcx and repeat mainloop
  loopq mainloop

finish:
  movq $60, %rax
  syscall 
