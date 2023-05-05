#!/usr/bin/env sh

# REQUIRES: shell

# RUN: rm -rf %T/lib* %T/other

# RUN: ar qc %T/libmy.a
# RUN: mkdir %T/other
# RUN: ar qc %T/other/libmy.a

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/some_dir_for_libs.c -files %T/other/libmy.a -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -lmy -o some_dir_for_libs.c.o some_dir_for_libs.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/other/libmy.a %T/some_dir_for_libs.c.o -directory %T -arguments %{c_compiler} -L ./other/ -L. -lmy some_dir_for_libs.c.o -o some_dir_for_libs

echo "int main() { return 0; }" > some_dir_for_libs.c

$CC -o some_dir_for_libs -L ./other/ -L. -lmy some_dir_for_libs.c
