# We add the number of siblings for each person to the data record
.section .data

.globl people, numpeople

numpeople:
  # Calculate number of people in array
  .quad (endpeople - people) / PERSON_RECORD_SIZE

people:
  # Array of people
  .ascii "Gilbert Keith Chester\0"
  .quad 200, 10, 2, 74, 20, 3
  .ascii "Jonathan Bartlett\0"
  .quad 280, 12, 2, 72, 44, 1
  .ascii "Clive Silver Lewis\0"
  .quad 150, 8, 1, 68, 30, 2
  .ascii "Clive Silver Lewis\0"
  .quad 150, 8, 1, 68, 30, 2
  .ascii "Tommy Aquinas\0"
  .quad 250, 14, 3, 75, 24, 4
  .ascii "Isaac Newn\0"
  .quad 250, 10, 4, 70, 11, 1
  .ascii "Gregory Mend\0"
  .quad 180, 11, 5, 69, 65, 3
endpeople: # Marks the end of the array for calculation purposes

# Describe components of the struct
.globl NAME_OFFSET, WEIGHT_OFFSET, SHOE_OFFSET
.globl HAIR_OFFSET, HEIGHT_OFFSET, AGE_OFFSET
.globl SIBLINGS_OFFSET
.equ NAME_OFFSET, 0
.equ WEIGHT_OFFSET, 32
.equ SHOE_OFFSET, 40
.equ HAIR_OFFSET, 48
.equ HEIGHT_OFFSET, 56
.equ AGE_OFFSET, 64
.equ SIBLINGS_OFFSET, 72

# Total size of the struct
.globl PERSON_RECORD_SIZE
.equ PERSON_RECORD_SIZE, 80
