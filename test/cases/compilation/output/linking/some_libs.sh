#!/usr/bin/env sh

# REQUIRES: shell

# RUN: rm -rf %T/lib* %T/other

# RUN: ar qc %T/libmy.a
# RUN: mkdir %T/other
# RUN: ar qc %T/other/libmy.a
# RUN: touch %T/libmy.%{dynamic_lib_extension}

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/some_libs.c -files -directory %T -arguments %{c_compiler} -c -L. -L ./other/ -lmy -o some_libs.c.o some_libs.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/libmy.%{dynamic_lib_extension} %T/some_libs.c.o -directory %T -arguments %{c_compiler} -L. -L ./other/ -lmy some_libs.c.o -o some_libs

echo "int main() { return 0; }" > some_libs.c

$CC -o some_libs -L. -L ./other/ -lmy some_libs.c
