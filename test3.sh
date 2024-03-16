#!/bin/bash

make clean
make microc.native
./microc.native example.mc > example.ll
llc -relocation-model=pic example.ll > example.s
gcc -c printbig.c
cc -o example.exe example.s printbig.o