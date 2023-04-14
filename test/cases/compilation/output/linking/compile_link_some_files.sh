#!/usr/bin/env sh

# REQUIRES: shell
# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 2
# RUN: assert_compilation %t.json contains -file %T/compile_link_some_files_1.c -directory %T -arguments %{c_compiler} -c lib.o -o compile_link_some_files_1.c.o compile_link_some_files_1.c
# RUN: assert_compilation %t.json contains -file %T/compile_link_some_files_2.c -directory %T -arguments %{c_compiler} -c lib.o -o compile_link_some_files_2.c.o compile_link_some_files_2.c
# RUN: assert_compilation %t_link.json count -eq 2
# RUN: assert_compilation %t_link.json contains -files %T/lib.o %T/compile_link_some_files_1.c.o %T/compile_link_some_files_2.c.o -directory %T -arguments %{c_compiler} lib.o compile_link_some_files_1.c.o compile_link_some_files_2.c.o -o compile_link_some_files

touch lib.o

echo "int foo() { return 1; }" > compile_link_some_files_1.c
echo "int main() { return 0; }" > compile_link_some_files_2.c

$CC lib.o compile_link_some_files_1.c -o compile_link_some_files compile_link_some_files_2.c
