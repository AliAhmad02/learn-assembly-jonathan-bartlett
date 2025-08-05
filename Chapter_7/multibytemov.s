.globl _start

.section .data
mytext:
  .ascii "This is a string of characters.\0"

.section .text
_start:
  # Move a pointer to the string into %rbx
  movq $mytext, %rbx

  # Count starts at zero
  movq $0, %rdi
  
mainloop:
  # Get the next quadword
  movq (%rbx), %rax

byte1:
  # Check if the rightmost byte (remember little endian) is zero.ifnes
  cmpb $0, %al
  # If it is, we're done
  je finish

  # If the rightmost byte is not lowercase, jump to the second byte
  cmpb $'a', %al
  jb byte2

  cmpb $'z', %al
  ja byte2
  
  # Else, increment the counter, %rdi
  incq %rdi

byte2:
  # Same as byte1, except we use the %ah register
  cmpb $0, %ah
  je finish

  cmpb $'a', %ah
  jb byte3

  cmpb $'z', %ah
  ja byte3
  incq %rdi

byte3:
  # Rotate 16 bits to the right, so that %ah and %al now have the
  # next two characters in the string
  rorq $16, %rax

  # After this, it's essentially byte1 all over again 
  cmpb $0, %al
  je finish

  cmpb $'a', %al
  jb byte4

  cmpb $'z', %al
  ja byte4
  
  incq %rdi
  
byte4:
  # Essentially byte2 all over again
  cmpb $0, %ah
  je finish

  cmpb $'a', %ah
  jb byte5

  cmpb $'z', %ah
  ja byte3

  incq %rdi

byte5:
  # Once again, rotate 16 bits to the right
  rorq $16, %rax

  cmpb $0, %al
  je finish

  cmpb $'a', %al
  jb byte6

  cmpb $'z', %al
  ja byte6
  
  incq %rdi

byte6:
  cmpb $0, %ah
  je finish

  cmpb $'a', %ah
  jb byte7

  cmpb $'z', %ah
  ja byte7

  incq %rdi

byte7: 
  rorq $16, %rax

  cmpb $0, %al
  je finish

  cmpb $'a', %al
  jb byte8

  cmpb $'z', %al
  ja byte8
  
  incq %rdi

byte8:
  cmpb $0, %ah
  je finish

  # If it is not lowercase, go to loopcontrol
  cmpb $'a', %ah
  jb loopcontrol

  cmpb $'z', %ah
  ja loopcontrol

  # Otherwise, increment the count and then go to loopcontrol
  incq %rdi

loopcontrol:
  # Add 8 bytes to the pointer and go back to the start of the program
  # What we're doing here is that above, we have processed all 8 bytes
  # of the quadword. But we're still not done with the whole string.
  # So we want to get the next 8 bytes, process those and so on
  addq $8, %rbx
  jmp mainloop

finish:
  movq $60, %rax
  syscall
