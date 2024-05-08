compiler:
	ocamlbuild -clean
	rm -f example.s example.ll example.exe binding.o binding

	@echo "Compiling, please wait..."
	opam config exec -- \
	ocamlbuild -use-ocamlfind grepql.native > /dev/null 2>&1

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
	@echo "The following executable is ready to run..."
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
