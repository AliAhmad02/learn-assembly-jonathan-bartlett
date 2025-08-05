# Program counts # of brown/blonde-haired people in persondata
.globl _start
.section .text

_start:

  # Pointer to first record
  leaq people, %rbx

  # Total record count
  movq numpeople, %rcx

  # Brown hair count
  movq $0, %rdi

  # If there are no records, we are done
  cmpq $0, %rcx
  je finish

mainloop:
  # Is the hair color brown (2)?
  cmpq $2, HAIR_OFFSET(%rbx)

  # No? Check if it is blonde
  jne blonde_check

  # Yes? Increment the count and jump to end
  incq %rdi
  jmp endloop

blonde_check: 
  # Is the hair color blonde (3)?
  cmpq $3, HAIR_OFFSET(%rbx)

  # No? jump to endloop
  jne endloop

  # Yes? Increment the count
  incq %rdi

endloop:
  addq $PERSON_RECORD_SIZE, %rbx
  loopq mainloop

finish:
  movq $60, %rax
  syscall
