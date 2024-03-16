#!/bin/bash

rm test_scanner.native
ocamlbuild test_scanner.native
cat example.mc | ./test_scanner.native