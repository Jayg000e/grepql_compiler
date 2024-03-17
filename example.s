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
	movq	%rdi, 8(%rsp)
	leaq	.Ltmp.3(%rip), %r9
	movq	%r9, (%rsp)
	xorl	%esi, %esi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	callq	query@PLT
	movq	%rax, 16(%rsp)
	movq	%rax, %rdi
	callq	show@PLT
	leaq	.Ltmp.4(%rip), %r9
	movq	%r9, (%rsp)
	movq	8(%rsp), %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	xorl	%r8d, %r8d
	callq	query@PLT
	movq	%rax, 16(%rsp)
	movq	%rax, %rdi
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
	.asciz	"^sast.*"
	.size	.Ltmp.3, 8

	.type	.Ltmp.4,@object         # @tmp.4
.Ltmp.4:
	.asciz	".*\\.c$"
	.size	.Ltmp.4, 7

	.section	".note.GNU-stack","",@progbits
