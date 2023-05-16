#!/usr/bin/env sh

# REQUIRES: shell

# RUN: echo "int foo() { return 1; }" > %T/libflag_static.c
# RUN: gcc -c -o %T/libflag_static.o %T/libflag_static.c
# RUN: ar -q -c %T/libflag_static.a %T/libflag_static.o
# RUN: touch %T/libflag_static.%{dynamic_lib_extension}

# RUN: mkdir -p %T/other
# RUN: echo "int foo1() { return 1; }" > %T/other/libflag_static.c
# RUN: gcc -c -o %T/other/libflag_static.o %T/other/libflag_static.c
# RUN: ar -q -c %T/other/libflag_static.a %T/other/libflag_static.o

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/flag_static.c -files %T/other/libflag_static.a -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -lflag_static -static -o flag_static.c.o flag_static.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/other/libflag_static.a %T/flag_static.c.o -directory %T -arguments %{c_compiler} -L ./other/ -L. -lflag_static -static flag_static.c.o -o flag_static

echo "int main() { return 0; }" > flag_static.c

$CC -o flag_static -L ./other/ -L. -lflag_static -static flag_static.c
