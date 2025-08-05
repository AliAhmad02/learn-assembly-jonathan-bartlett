.globl _start
.section .text

_start:
  # Load memory address of array start into %rbx
  leaq people, %rbx

  # Initialize the value of the youngest age with the age of the first person
  movq AGE_OFFSET(%rbx), %rdi

  # %rdx will hold the value of %rcx corresponding to the youngest person
  movq $6, %rdx

  # Initialize %rcx to hold length of array
  movq numpeople, %rcx

  # If there are no records, we are done
  cmpq $0, %rcx
  je finish

  # Since %rdi already holds the youngest age, we can decrement %rcx by 1
  # skipping comparing the first person to himself. Although we will need
  # to add 32 (the size of a person) when we get the current person.
  decq %rcx

mainloop:
  # Move the age of the current person into %rax. We have to add 32 manually
  # instead of using PERSON_RECORD_SIZE, because the assembler replaces
  # constants with their values at assembly time. However, at that time,
  # PERSON_RECORD_SIZE is not known to the assembler, since it is defined
  # in a different files. Thus, it will only be known after the linker has
  # linked them together
  movq AGE_OFFSET+32(%rbx), %rax

  # If it is larger than or equal to current youngest, go to next one
  cmpq %rdi, %rax
  jae endloop

  # Otherwise, update the current youngest and save %rcx for the youngest
  # person in %rdx
  movq %rax, %rdi
  movq %rcx, %rdx

endloop:
  # Move %rbx to point to the next record
  addq $PERSON_RECORD_SIZE, %rbx

  # Decrement %rbx and loop
  loopq mainloop

finish:
  # An index can be calculated from the counter (%rcx value stored in %rdx) by
  # numpeople-%rdx. We move numpeople into %rdi, then we do the
  # subtraction, which leaves us with the index in %rdi.
  movq numpeople, %rdi
  subq %rdx, %rdi
  movq $60, %rax
  syscall
