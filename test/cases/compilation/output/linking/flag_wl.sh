#!/usr/bin/env sh

# REQUIRES: shell

# RUN: rm -rf %T/lib* %T/other

# RUN: touch %T/libx.%{dynamic_lib_extension}
# RUN: ar qc %T/liby.a
# RUN: touch %T/liby.%{dynamic_lib_extension}

# RUN: mkdir %T/other
# RUN: ar qc %T/other/libmy.a
# RUN: ar qc %T/other/libx.a
# RUN: touch %T/other/libmy.%{dynamic_lib_extension}
# RUN: touch %T/other/libx.%{dynamic_lib_extension}

# RUN: cd %T; %{bear} --verbose --with-link --output-compile %t.json --output-link %t_link.json -- %{shell} %s
# RUN: assert_compilation %t.json count -eq 1
# RUN: assert_compilation %t.json contains -file %T/flag_wl.c -files -directory %T -arguments %{c_compiler} -c -L ./other/ -Wl,-Bdynamic,-Bstatic -lmy -lx -L. -Wl,-Bdynamic -lx -ly -o flag_wl.c.o flag_wl.c
# RUN: assert_compilation %t_link.json count -eq 1
# RUN: assert_compilation %t_link.json contains -files %T/flag_wl.c.o %T/other/libmy.a %T/other/libx.a %T/other/libx.%{dynamic_lib_extension} %T/liby.%{dynamic_lib_extension} -directory %T -arguments %{c_compiler} flag_wl.c.o -L ./other/ -Wl,-Bdynamic,-Bstatic -lmy -lx -L. -Wl,-Bdynamic -lx -ly -o flag_wl

echo "int main() { return 0; }" > flag_wl.c

$CC -o flag_wl flag_wl.c -L ./other/ -Wl,-Bdynamic,-Bstatic -lmy -lx -L. -Wl,-Bdynamic -lx -ly
