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

# "make clean" removes all generated files
.PHONY : clean
clean :
	ocamlbuild -clean
	rm -f *.s *.ll *.exe *.txt binding.o binding

# you should run "make compiler" before make test
# example usage: make test input=append.g the append.g file should be in the /tests directory
.PHONY: test
test: 
	./grepql.native tests/$(input) > $(basename $(input)).ll
	llc -relocation-model=pic $(basename $(input)).ll > $(basename $(input)).s
	gcc -c binding.c
	cc -o $(basename $(input)).exe $(basename $(input)).s binding.o
	./$(basename $(input)).exe

# you should run "make compiler" before make all_tests
all_tests: 
	@for file in tests/*.g; do \
		base=$$(basename $$file .g); \
		echo "Compiling $$base..."; \
		./grepql.native $$file > $$base.ll && \
		llc -relocation-model=pic $$base.ll > $$base.s && \
		gcc -c binding.c && \
		cc -o $$base.exe $$base.s binding.o && \
		echo "Running $$base..."; \
		./$$base.exe; \
		if [ $$? -ne 0 ]; then \
			echo "Failed to run $$base"; \
			exit 1; \
		fi; \
	done; \
	echo "All files compiled and ran successfully!"
