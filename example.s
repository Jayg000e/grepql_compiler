	.text
	.file	"MicroC"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -16
	leaq	.Ltmp(%rip), %rax
	movq	%rax, 16(%rsp)
	callq	newStrings@PLT
	movq	%rax, 8(%rsp)
	leaq	.Ltmp.3(%rip), %rcx
	movq	%rcx, 16(%rsp)
	leaq	.Ltmp.4(%rip), %rsi
	movq	%rax, %rdi
	callq	append@PLT
	movq	8(%rsp), %rdi
	leaq	.Ltmp.5(%rip), %rsi
	callq	append@PLT
	movq	8(%rsp), %rdi
	callq	show@PLT
	movq	8(%rsp), %rdi
	callq	size@PLT
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	16(%rsp), %rdi
	callq	query@PLT
	movq	%rax, 8(%rsp)
	movq	%rax, %rdi
	callq	size@PLT
	movq	%rbx, %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	8(%rsp), %rdi
	callq	show@PLT
	xorl	%eax, %eax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
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
	.asciz	"asdasd"
	.size	.Ltmp, 7

	.type	.Ltmp.3,@object         # @tmp.3
.Ltmp.3:
	.asciz	"/home/jayg/Documents/cs4115/grepql_compiler"
	.size	.Ltmp.3, 44

	.type	.Ltmp.4,@object         # @tmp.4
.Ltmp.4:
	.asciz	"hello"
	.size	.Ltmp.4, 6

	.type	.Ltmp.5,@object         # @tmp.5
.Ltmp.5:
	.asciz	"nononon"
	.size	.Ltmp.5, 8

	.section	".note.GNU-stack","",@progbits
