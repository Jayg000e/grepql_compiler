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
	movl	$1, 12(%rsp)
	leaq	.Ltmp(%rip), %rax
	movq	%rax, 16(%rsp)
	leaq	.Ltmp.3(%rip), %rax
	movq	%rax, 24(%rsp)
	leaq	.Lfmt(%rip), %rbx
	movq	%rbx, %rdi
	movl	$2, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	12(%rsp), %esi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	24(%rsp), %rsi
	leaq	.Lfmt.2(%rip), %rbx
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	s2@GOTPCREL(%rip), %rax
	movq	(%rax), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	16(%rsp), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
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
	.globl	add                     # -- Begin function add
	.p2align	4, 0x90
	.type	add,@function
add:                                    # @add
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%edi, 4(%rsp)
	movl	%esi, (%rsp)
	movq	s2@GOTPCREL(%rip), %rax
	movq	(%rax), %rsi
	leaq	.Lfmt.6(%rip), %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	4(%rsp), %eax
	addl	(%rsp), %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	add, .Lfunc_end1-add
	.cfi_endproc
                                        # -- End function
	.type	s2_str,@object          # @s2_str
	.bss
	.globl	s2_str
s2_str:
	.zero	1
	.size	s2_str, 1

	.type	s2,@object              # @s2
	.data
	.globl	s2
	.p2align	3
s2:
	.quad	s2_str
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
	.asciz	"tttt"
	.size	.Ltmp, 5

	.type	.Ltmp.3,@object         # @tmp.3
.Ltmp.3:
	.asciz	"sss"
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
