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
	callq	newStrings@PLT
	movq	%rax, (%rsp)
	leaq	.Ltmp(%rip), %rsi
	movq	%rax, %rdi
	callq	append@PLT
	movq	(%rsp), %rdi
	leaq	.Ltmp.3(%rip), %rsi
	callq	append@PLT
	movq	(%rsp), %rdi
	callq	show@PLT
	movq	(%rsp), %rdi
	callq	size@PLT
	leaq	.Lfmt(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
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
	.asciz	"hello"
	.size	.Ltmp, 6

	.type	.Ltmp.3,@object         # @tmp.3
.Ltmp.3:
	.asciz	"nononon"
	.size	.Ltmp.3, 8

	.section	".note.GNU-stack","",@progbits
