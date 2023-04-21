#!/usr/bin/env sh

# REQUIRES: shell
# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 2
# RUN: assert_compilation %t.json contains -file %T/clang_1.c -directory %T -arguments %{clang_compiler} -c -o clang_1.c.o clang_1.c
# RUN: assert_compilation %t.json contains -file %T/clang_2.c -directory %T -arguments %{clang_compiler} -c -o clang_2.c.o clang_2.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/clang_1.c.o %T/clang_2.c.o -directory %T -arguments %{clang_compiler} clang_1.c.o clang_2.c.o -o res

echo "int foo() { return 1; }" > clang_1.c
echo "int main() { return 0; }" > clang_2.c

$CLANG clang_1.c -o res clang_2.c
