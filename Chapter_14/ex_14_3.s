.globl allocate, deallocate

.section .data
memory_start:
  .quad 0
memory_end:
  .quad 0

.section .text
# We do not only allocate the requested memory, but also two quadwords extra
# as the "header". The two qwords tell us whether the memory is in use and
# its size
.equ HEADER_SIZE, 16
.equ HDR_IN_USE_OFFSET, 0
.equ HDR_SIZE_OFFSET, 8

.equ BRK_SYSCALL, 12

# Register usage:
# - %rdx - size requested
# - %rsi - pointer to current memory being examined
# - %rcx copy of memory_end

allocate_init:
  # Find the program break
  movq $0, %rdi
  movq $BRK_SYSCALL, %rax
  syscall

  # The current break will be both the start and the end of our memory
  movq %rax, memory_start
  movq %rax, memory_end
  jmp allocate_continue

allocate_move_break:
  # Old break is saved in %r8 to return to user
  movq %rcx, %r8
  # Calculate where we want the new break to be
  # (old break + size)
  movq %rcx, %rdi
  addq %rdx, %rdi
  # Save this value
  movq %rdi, memory_end

  # Tell Linux where the new break is
  movq $BRK_SYSCALL, %rax
  syscall

  # Adress is in %r8, mark size and availability
  movq $1, HDR_IN_USE_OFFSET(%r8)
  movq %rdx, HDR_SIZE_OFFSET(%r8)

  # Actual return value is beyond our header
  addq $HEADER_SIZE, %r8
  movq %r8, %rax
  ret

allocate:
  # We round the requested memory up to the nearest multiple of 16 using the
  # formula %rdi + (16 - %rdi % 16). The reason we can do this now is that
  # later, we just add the header size, but that's just 16 anyway, so it will
  # still be a multiple of 16
  movq %rdi, %rax
  movq $16, %rcx
  movq $0, %rdx
  divq %rcx
  addq $16, %rdi
  subq %rdx, %rdi
  # Move the requested amount into %rdx
  movq %rdi, %rdx
  
  # Add header size
  addq $HEADER_SIZE, %rdx

  # If we haven't initialized, do so
  cmpq $0, memory_start
  je allocate_init

allocate_continue:
  movq memory_start, %rsi
  movq memory_end, %rcx

allocate_loop:
  # Compare memory_start and memory_end. If they are the same, we need to move
  # the program break, because we have reached the end of the memory
  cmpq %rsi, %rcx
  
  je allocate_move_break

  # Is the next block available? If it isn't, try next block
  cmpq $0, HDR_IN_USE_OFFSET(%rsi)
  jne try_next_block

  # Is the next block big enough? If it isn't, try next block
  cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
  jb try_next_block

  # This block is great! Mark it as unavailable
  movq $1, HDR_IN_USE_OFFSET(%rsi)
  # We want to return the memory address immediately after the header
  addq $HEADER_SIZE, %rsi
  # Return the memory address
  movq %rsi, %rax
  ret

try_next_block:
  # This block didn't work, move to the next one by adding the block size
  # to the memory_start value
  addq HDR_SIZE_OFFSET(%rsi), %rsi
  jmp allocate_loop

deallocate:
  # Free is simple - just mark the block as available
  movq $0, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
  ret
