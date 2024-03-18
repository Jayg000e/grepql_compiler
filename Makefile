# The _tags file controls the operation of ocamlbuild, e.g., by including
# packages, enabling warnings
#
# See https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc


scanner:
	rm -f test_scanner.native
	ocamlbuild test_scanner.native
	cat example.g | ./test_scanner.native

parser:
	rm -f test_parser.native
	ocamlbuild test_parser.native
	cat example.g | ./test_parser.native

semant:
	rm -f test_semmant.native
	ocamlbuild test_semmant.native
	cat example.g | ./test_semmant.native

binding : binding.c
	cc -o binding -DBUILD_TEST binding.c 

grepql.native :
	opam config exec -- \
	ocamlbuild -use-ocamlfind grepql.native

compiler:
	ocamlbuild -clean
	rm -f example.s example.ll example.exe binding.o binding

	opam config exec -- \
	ocamlbuild -use-ocamlfind grepql.native
	./grepql.native example.g > example.ll
	llc -relocation-model=pic example.ll > example.s
	gcc -c binding.c
	cc -o example.exe example.s binding.o

# "make clean" removes all generated files
.PHONY : clean
clean :
	ocamlbuild -clean
	rm -f example.s example.ll example.exe binding.o binding


