#!/bin/bash
rm test_parser.native
ocamlbuild test_parser.native
cat example.mc | ./test_parser.native