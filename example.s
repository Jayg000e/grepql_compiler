	.text
	.file	"MicroC"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	leaq	.Ltmp(%rip), %rdi
	movq	%rdi, 16(%rsp)
	movq	s2@GOTPCREL(%rip), %r14
	movq	%rdi, (%r14)
	leaq	.Ltmp.3(%rip), %rsi
	movq	%rsi, 8(%rsp)
	callq	concat@PLT
	movq	%rax, (%rsp)
	leaq	.Lfmt.2(%rip), %rbx
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	16(%rsp), %rsi
	movq	8(%rsp), %rdi
	callq	concat@PLT
	movq	%rax, (%rsp)
	movq	8(%rsp), %rdi
	movq	%rax, %rsi
	callq	concat@PLT
	movq	%rax, (%rsp)
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	16(%rsp), %rdi
	callq	cat3@PLT
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$100, %edi
	callq	printbig@PLT
	movq	(%r14), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	cat3                    # -- Begin function cat3
	.p2align	4, 0x90
	.type	cat3,@function
cat3:                                   # @cat3
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 16(%rsp)
	movq	%rdi, %rsi
	callq	concat@PLT
	movq	%rax, 8(%rsp)
	movq	16(%rsp), %rsi
	movq	%rax, %rdi
	callq	concat@PLT
	movq	%rax, 8(%rsp)
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	cat3, .Lfunc_end1-cat3
	.cfi_endproc
                                        # -- End function
	.type	s2,@object              # @s2
	.bss
	.globl	s2
	.p2align	3
s2:
	.quad	0
	.size	s2, 8

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
	.asciz	"abc"
	.size	.Ltmp, 4

	.type	.Ltmp.3,@object         # @tmp.3
.Ltmp.3:
	.asciz	"cba"
	.size	.Ltmp.3, 4

	.type	.Lfmt.4,@object         # @fmt.4
.Lfmt.4:
	.asciz	"%d\n"
	.size	.Lfmt.4, 4

	.type	.Lfmt.5,@object         # @fmt.5
.Lfmt.5:
	.asciz	"%g\n"
	.size	.Lfmt.5, 4

	.type	.Lfmt.6,@object         # @fmt.6
.Lfmt.6:
	.asciz	"%s\n"
	.size	.Lfmt.6, 4

	.section	".note.GNU-stack","",@progbits
