#!/usr/bin/env sh

# REQUIRES: shell

# RUN: rm -rf %T/lib* %T/other

# RUN: ar qc %T/libmy.a

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/with_static_lib.c -files -directory %T -arguments %{c_compiler} -c -L. -lmy -o with_static_lib.c.o with_static_lib.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/libmy.a %T/with_static_lib.c.o -directory %T -arguments %{c_compiler} -L. -lmy with_static_lib.c.o -o with_static_lib

echo "int main() { return 0; }" > with_static_lib.c

$CC -o with_static_lib -L. -lmy with_static_lib.c
