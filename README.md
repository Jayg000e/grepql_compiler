# GREPQL Compiler

Welcome to the GREPQL Compiler repository! This document provides instructions on how to set up and use the GREPQL Compiler for compiling and running GREPQL scripts. GREPQL is designed to enhance querying capabilities within file systems using a syntax similar to SQL combined with the power of regular expressions.

## Version Requirements

Ensure you have the correct versions of opam, ocaml, ocamlbuild and LLVM installed to compile and run the GREPQL Compiler:

- **Opam Version**
  Check the installed version of Opam:
  ```bash
  opam --version
  ```
  This compiler requires opam version 2.0.5.

- **OCaml Version**
  Check the installed version of OCaml:
  ```bash
  ocaml --version
  ```
  This compiler requires OCaml version 4.08.1.

- **OCamlbuild Version**
  Check the installed version of OCamlbuild:
  ```bash
  ocamlbuild --version
  ```
  This compiler requires OCamlbuild version 0.14.0.

- **LLVM Version**
  Check the installed version of LLVM:
  ```bash
  llvm-config --version
  ```
  LLVM version 10.0.0 is required.

## Getting Started

Follow these steps to compile and start using the GREPQL Compiler.

### Compiling the Compiler

To generate the compiler executable, run the following command in the terminal:
```bash
make compiler
```
This command compiles all necessary source files and generates the executable needed to run GREPQL scripts.

### Running Test Cases

Test cases are located in the `/tests` directory. You can run specific test cases or all tests as described below:

- **Running a Specific Test Case**
  
  To run a specific test case, use the `make test` command with the `input` variable specifying the script to run. For example, to run the `demo2_grep.g` test script, use:
  ```bash
  make test input=demo2_grep.g
  ```

- **Running All Test Cases**

  To execute all test scripts in the `/tests` directory, use:
  ```bash
  make all_tests
  ```
  This command will sequentially compile and execute each test script, outputting the results to the console.
### Run your own grepql program

1. Write your own your_file_name.g file in /tests

2. Compile and run it by:

```bash
  make test input=your_file_name.g
  ```

## Additional Information

- The GREPQL Compiler supports a variety of commands and queries typical to data retrieval and manipulation tasks. Refer to the [GREPQL Command Reference](https://drive.google.com/file/d/10ltsyyzCuSjXZ-eB4PknFGg3zn5YAkVQ/view?usp=sharing) and [GREPQL Report](https://drive.google.com/file/d/10lyo40QwWk1if8GRefZOezLSMzml-QCw/view?usp=sharing) for detailed syntax and examples.


Thank you for using the GREPQL Compiler. We hope it enhances your data processing tasks efficiently!







