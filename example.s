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
	movq	%rax, 8(%rsp)
	leaq	.Ltmp(%rip), %rsi
	movq	%rax, %rdi
	callq	append@PLT
	movq	8(%rsp), %rdi
	leaq	.Ltmp.3(%rip), %rsi
	callq	append@PLT
	movq	8(%rsp), %rdi
	callq	display_strings_info@PLT
	leaq	.Ltmp.4(%rip), %rsi
	movq	%rsi, 16(%rsp)
	movq	8(%rsp), %rdi
	callq	append@PLT
	movq	8(%rsp), %rdi
	callq	display_strings_info@PLT
	leaq	.Ltmp.5(%rip), %rsi
	movq	%rsi, 16(%rsp)
	movq	8(%rsp), %rdi
	callq	append@PLT
	movq	8(%rsp), %rdi
	callq	display_strings_info@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	display_strings_info    # -- Begin function display_strings_info
	.p2align	4, 0x90
	.type	display_strings_info,@function
display_strings_info:                   # @display_strings_info
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	movq	%rdi, 8(%rsp)
	leaq	.Lfmt.8(%rip), %rbx
	leaq	.Ltmp.9(%rip), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	8(%rsp), %rdi
	callq	size@PLT
	leaq	.Lfmt.6(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	leaq	.Ltmp.10(%rip), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	8(%rsp), %rdi
	callq	show@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	display_strings_info, .Lfunc_end1-display_strings_info
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
	.asciz	"world"
	.size	.Ltmp.3, 6

	.type	.Ltmp.4,@object         # @tmp.4
.Ltmp.4:
	.asciz	"goodbye"
	.size	.Ltmp.4, 8

	.type	.Ltmp.5,@object         # @tmp.5
.Ltmp.5:
	.asciz	"world"
	.size	.Ltmp.5, 6

	.type	.Lfmt.6,@object         # @fmt.6
.Lfmt.6:
	.asciz	"%d\n"
	.size	.Lfmt.6, 4

	.type	.Lfmt.7,@object         # @fmt.7
.Lfmt.7:
	.asciz	"%g\n"
	.size	.Lfmt.7, 4

	.type	.Lfmt.8,@object         # @fmt.8
.Lfmt.8:
	.asciz	"%s\n"
	.size	.Lfmt.8, 4

	.type	.Ltmp.9,@object         # @tmp.9
.Ltmp.9:
	.asciz	"strings size:"
	.size	.Ltmp.9, 14

	.type	.Ltmp.10,@object        # @tmp.10
.Ltmp.10:
	.asciz	"strings element:"
	.size	.Ltmp.10, 17

	.section	".note.GNU-stack","",@progbits
