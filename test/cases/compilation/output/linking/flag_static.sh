#!/usr/bin/env sh

# REQUIRES: shell

# RUN: ar qc %T/libflag_static.a
# RUN: touch %T/libflag_static.%{dynamic_lib_extension}

# RUN: mkdir -p %T/other
# RUN: ar qc %T/other/libflag_static.a

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/flag_static.c -files %T/other/libflag_static.a -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -lflag_static -static -o flag_static.c.o flag_static.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/other/libflag_static.a %T/flag_static.c.o -directory %T -arguments %{c_compiler} -L ./other/ -L. -lflag_static -static flag_static.c.o -o flag_static

echo "int main() { return 0; }" > flag_static.c

$CC -o flag_static -static -L ./other/ -L. -lflag_static flag_static.c
