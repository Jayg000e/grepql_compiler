# grepql_compiler

## Test Programs

All tests program are in /tests directory. 


## Getting Started

To run /tests/condition.g:

1. copy content in condition.g and copy them inside the example.g in rootdir:

```bash
cp ./tests/condition.g example.g
```

2. run this command in the rootdir: 

```bash
make compiler
```

3. run:

```bash
./example.exe
```

You can verify that the output of condition.g is:

```bash
25
example.exe
ast.ml
test_semmant.ml
parse.mly
Makefile
grepql.native
_build
_tags
tests
.gitignore
test_parser.ml
test_scanner.ml
semant.ml
example.ll
grepql.ml
README.md
example.g
codegen.ml
.git
sast.ml
binding.c
.vscode
binding.o
example.s
scanner.mll
```


Follow the same steps to test regx.g

The following should be displayed in standard out:

```bash
sast.ml
binding.c
```

Follow the same steps to test strings.g

The following should be displayed in standard out:

```bash
strings size:
2
strings element:
hello
world
strings size:
3
strings element:
hello
world
goodbye
strings size:
4
strings element:
hello
world
goodbye
world
```

Follow the same steps to test udf.g

The following should be displayed in standard out:

```bash
25
example.exe
ast.ml
test_semmant.ml
parse.mly
Makefile
grepql.native
_build
_tags
tests
.gitignore
test_parser.ml
test_scanner.ml
semant.ml
example.ll
grepql.ml
README.md
example.g
codegen.ml
.git
sast.ml
binding.c
.vscode
binding.o
example.s
scanner.mll
```

## Work Completed

1. Support User Define Function
2. Support Select 
3. Support Dynamic array of string
4. Support Where base on file size, date, and regular expressions


## TODO

1. Support Grep        
2. Support array
3. Support indexing
4. Maybe some small feature like array literals?

## Version

```bash
ocaml -version
```
The OCaml toplevel, version 4.08.1

```bash
llvm-config --version
```
10.0.0










