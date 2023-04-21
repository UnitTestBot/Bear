#!/usr/bin/env sh

# REQUIRES: shell
# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 2
# RUN: assert_compilation %t.json contains -file %T/sources_with_libs_1.c -files %T/lib.o %T/lib1.so -directory %T -arguments %{c_compiler} -c lib.o lib1.so -o sources_with_libs_1.c.o sources_with_libs_1.c
# RUN: assert_compilation %t.json contains -file %T/sources_with_libs_2.c -files %T/lib.o %T/lib1.so -directory %T -arguments %{c_compiler} -c lib.o lib1.so -o sources_with_libs_2.c.o sources_with_libs_2.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/lib.o %T/sources_with_libs_1.c.o %T/lib1.so %T/sources_with_libs_2.c.o -directory %T -arguments %{c_compiler} lib.o sources_with_libs_1.c.o lib1.so sources_with_libs_2.c.o -o sources_with_libs


touch lib.o lib1.so

echo "int foo() { return 1; }" > sources_with_libs_1.c
echo "int main() { return 0; }" > sources_with_libs_2.c

$CC lib.o sources_with_libs_1.c lib1.so sources_with_libs_2.c -o sources_with_libs;
