#!/usr/bin/env sh

# REQUIRES: shell

# RUN: rm -rf %T/lib* %T/other

# RUN: ar qc %T/libmy.a
# RUN: mkdir %T/other
# RUN: ar qc %T/other/libmy.a
# RUN: touch %T/libmy.%{dynamic_lib_extension}

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/flag_static.c -files -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -lmy -static -o flag_static.c.o flag_static.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/other/libmy.a %T/flag_static.c.o -directory %T -arguments %{c_compiler} -L ./other/ -L. -lmy -static flag_static.c.o -o flag_static

echo "int main() { return 0; }" > flag_static.c

$CC -o flag_static -L ./other/ -L. -lmy -static flag_static.c
