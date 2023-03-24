#!/usr/bin/env sh

# REQUIRES: preload
# RUN: %{intercept} --verbose --output-compile %t.json -- %{shell} %s
# RUN: assert_intercepted %t.json count -ge 4
# RUN: assert_intercepted %t.json contains -program %{true}
# RUN: assert_intercepted %t.json contains -program %{shell} -arguments %{shell} %s

$TRUE &
$TRUE &
$TRUE &

wait
