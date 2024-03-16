#!/bin/bash
rm test_semmant.native
ocamlbuild test_semmant.native
cat example.mc | ./test_semmant.native