#!/usr/bin/env sh

# REQUIRES: shell

# RUN: ar qc %T/libsome_dir_for_libs.a

# RUN: mkdir -p %T/other
# RUN: ar qc %T/other/libsome_dir_for_libs.a

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/some_dir_for_libs.c -files %T/other/libsome_dir_for_libs.a -directory %T -arguments %{c_compiler} -c -L ./other/ -L. -lsome_dir_for_libs -o some_dir_for_libs.c.o some_dir_for_libs.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/other/libsome_dir_for_libs.a %T/some_dir_for_libs.c.o -directory %T -arguments %{c_compiler} -L ./other/ -L. -lsome_dir_for_libs some_dir_for_libs.c.o -o some_dir_for_libs

echo "int main() { return 0; }" > some_dir_for_libs.c

$CC -o some_dir_for_libs -L ./other/ -L. -lsome_dir_for_libs some_dir_for_libs.c
