#!/usr/bin/env sh

# REQUIRES: shell

# RUN: printf "int foo();" > %T/libflag_static.h
# RUN: printf "#include \"libflag_static.h\"\n int foo() { return 1; }" > %T/libflag_static.c
# RUN: gcc -c -I %T %T/libflag_static.c -o %T/libflag_static.o
# RUN: ar -q -c %T/libflag_static.a %T/libflag_static.o

# RUN: touch %T/libflag_static.%{dynamic_lib_extension}

# RUN: mkdir -p %T/other

# RUN: printf "int foo1();" > %T/other/libflag_static.h
# RUN: printf "#include \"libflag_static.h\"\n int foo1() { return 2; }" > %T/other/libflag_static.c
# RUN: gcc -c -I %T/other %T/other/libflag_static.c -o %T/other/libflag_static.o
# RUN: ar -q -c %T/other/libflag_static.a %T/other/libflag_static.o

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/flag_static.c -files %T/other/libflag_static.a -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -static -lflag_static -o flag_static.c.o flag_static.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/flag_static.c.o %T/other/libflag_static.a -directory %T -arguments %{c_compiler} -L ./other/ -L. -static flag_static.c.o -lflag_static -o flag_static

printf "#include \"other/libflag_static.h\"\n int main() { return foo1(); }" > flag_static.c

$CC -o flag_static -L ./other/ -L. -static flag_static.c -lflag_static
