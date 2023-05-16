#!/usr/bin/env sh

# REQUIRES: shell

# RUN: touch %T/libsome_libs.a
# RUN: touch %T/libsome_libs.%{dynamic_lib_extension}

# RUN: mkdir -p %T/other
# RUN: touch %T/other/libsome_libs.a

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/some_libs.c -files %T/libsome_libs.%{dynamic_lib_extension} -directory %T -arguments %{c_compiler} -c -L. -L ./other/ -lsome_libs -o some_libs.c.o some_libs.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/libsome_libs.%{dynamic_lib_extension} %T/some_libs.c.o -directory %T -arguments %{c_compiler} -L. -L ./other/ -lsome_libs some_libs.c.o -o some_libs

echo "int main() { return 0; }" > some_libs.c

$CC -o some_libs -L. -L ./other/ -lsome_libs some_libs.c
