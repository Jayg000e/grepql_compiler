	.text
	.file	"MicroC"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	leaq	.Ltmp(%rip), %rdi
	movq	%rdi, 16(%rsp)
	leaq	.Ltmp.3(%rip), %r8
	movq	%r8, 8(%rsp)
	movl	$2, %esi
	movl	$2, %edx
	xorl	%ecx, %ecx
	callq	query@PLT
	movq	%rax, (%rsp)
	movq	%rax, %rdi
	callq	size@PLT
	leaq	.Lfmt(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	(%rsp), %rdi
	callq	show@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.Lfmt,@object           # @fmt
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lfmt:
	.asciz	"%d\n"
	.size	.Lfmt, 4

	.type	.Lfmt.1,@object         # @fmt.1
.Lfmt.1:
	.asciz	"%g\n"
	.size	.Lfmt.1, 4

	.type	.Lfmt.2,@object         # @fmt.2
.Lfmt.2:
	.asciz	"%s\n"
	.size	.Lfmt.2, 4

	.type	.Ltmp,@object           # @tmp
.Ltmp:
	.asciz	"."
	.size	.Ltmp, 2

	.type	.Ltmp.3,@object         # @tmp.3
.Ltmp.3:
	.asciz	"2024-03-16"
	.size	.Ltmp.3, 11

	.section	".note.GNU-stack","",@progbits
