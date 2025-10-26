  # Compiled output from gcc, comments are me trying to understand
  # Generally, uses 32-bit integers for everything (makes sense,
  # since the C-program uses longs)
	.file	"ex_16_1.c"
	.text
	.globl	array_sum
	.type	array_sum, @function
array_sum:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
  # %rdi and %rsi are for the function parameters, so I think it is storing
  # the function parameters on the stack
  # It also makes sense that the first parameter is in a 64-bit register
  # because that's the array (which is just a memory address), which must
  # be 64 bits. However, the second parameter is just the length, an integer,
  # which is why it's in a 32 bit register
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
  # Jump to .L2
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
  # Instruction: Convert long to quad, i.e. %eax->%rax, I assume
	cltq
  # Here, %rax is still just zero in the start, so we load zero into %rdx
	leaq	0(,%rax,4), %rdx
  # We move the address of the first element into %rax
	movq	-24(%rbp), %rax
  # We add 0 to the address of the start of the array, store result in %rax
	addq	%rdx, %rax
  # Move the first element of the array into %eax
	movl	(%rax), %eax
  # Add the first element to -8(%rbp) (which I'm assuming is where the total
  # sum is going to be stored)
	addl	%eax, -8(%rbp)
  # Add 1 to -4(%rbp), which I'm assuming is a sort of index
	addl	$1, -4(%rbp)
  # So then, when we go to .L2 again we have added 1 to %eax every time, so
  # eventually, when we have gone through the whole array we will no
  # longer jump to .L3 and just return. Indeed, this makes sense because we
  # move -8(%rbp) (which I just said was the sum) into %eax (where the return
  # value goes) before returning.
  # As far as how we iterate through the array, now in the start of .L3, we
  # are adding one to the value in %eax every time. This gets multiplied by
  # 4 and put into %rdx (see line 33). So we are calculating the offset from
  # the first element. Then in line 37 we add this offset to the address of
  # the start of the array and thus, %rax now has the address of the element
  # of interest and from then on, we simply move the value at that address
  # into %eax and add it to the local variable where the sum is stored
.L2:
	movl	-4(%rbp), %eax
  # Here, in the beginning, %eax will just be zero and -28(%rbp) will be the
  # stack variable for the length. So it is saying that if zero is less than
  # the length of the array, then jump to .L3, otherwise we just return 0
	cmpl	-28(%rbp), %eax
	jl	.L3
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	array_sum, .-array_sum
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
  # Storing the whole array on the stack
	movl	$1, -32(%rbp)
	movl	$2, -28(%rbp)
	movl	$3, -24(%rbp)
	movl	$4, -20(%rbp)
	movl	$5, -16(%rbp)
	movl	$6, -12(%rbp)
  # Reason we store 6 twice is because it's both the final element & the length
	movl	$6, -40(%rbp)
  # Move the length of the array into %edx
	movl	-40(%rbp), %edx
  # Move the address of the first element into %rax
	leaq	-32(%rbp), %rax
  # Move the above two things into the registers for function parameters to
  # array_sum
	movl	%edx, %esi
	movq	%rax, %rdi
	call	array_sum
  # Move the return value (i.e. the sum) onto the stack
	movl	%eax, -36(%rbp)
	movq	stdout(%rip), %rax
  # Move the sum into %edx (where the varargs for fprintf go)
	movl	-36(%rbp), %edx
  # Load the address of the format string into %rcx
	leaq	.LC0(%rip), %rcx
  # Move the arguments for fprintf into the appropriate registers
	movq	%rcx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
  # Set return value to zero
	movl	$0, %eax
  # Clean up the stack
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.1 20250813"
	.section	.note.GNU-stack,"",@progbits
  # Reason we store 6 twice is because it's both the final element & the length
