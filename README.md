Bazel Rules for Raspberry Pi Pico
=================================

This repository contains experimental rules for building the Raspberry Pi Pico SDK with bazel.
This is mostly for my own benefit since it made it easier to integrate with some of my other
projects which already use bazel.

Originally, the intention was to use the excellent rules_foreign_cc library to bridge between
bazel and cmake but this ended up being difficult due to the need for cross compilation and
the extensive use of cmake interface libraries in the Pico C/C++ SDK and I ended up writing
bazel native build rules.

To use this in a project, just add the following to your WORKSPACE file:

```
git_repository(
    name = "rules_pico",
    branch = "main",
    remote = "http://gitlab.home.rabson.org/dfr/rules_pico.git",
)

load("@rules_pico//pico:repositories.bzl", "rules_pico_dependencies", "rules_pico_toolchains")

rules_pico_dependencies()
rules_pico_toolchains()
```

A bazel toolchain is included which allows the use of the standard arm-none-eabi toolchain for
building the Pico libraries. To make use of this, select the pico plaform in your .bazelrc:

```
build --incompatible_enable_cc_toolchain_resolution
build --platforms=//:pico
```
The approach is to download the Pico SDK sources from github using bazel's
new_git_repository rule and inject a BUILD file which handles most of the build, following
the Pico SDK library structure as closely as possible. Linking binaries for the Pico is
handled using bazel macros which include the necessary boot code and memory layout for
compatiblity with Pico.

The SDK libraries can be added as dependencies in the usual way
and the result is an ELF format binary which can be further transformed to UF2:

```
load("//pico:defs.bzl", "pico_binary")
load("//pico:defs.bzl", "pico_add_uf2_output")

pico_binary(
    name = "hello.elf",
    srcs = [
        "hello.c",
    ],
    deps = [
        "@rules_pico//pico:pico_stdlib",
    ],
)

pico_add_uf2_output(
    name = "hello_serial.uf2",
    input = "hello_serial.elf",
)
```

A very small subset of Pico SDK configuration options are defined in @rules_pico/pico/config
and these can be overridden on the bazel command line or via .bazelrc. Right now, this is
limited to selecting the board name and selecting output options for stdio. A very experimental
rule, pico_build_with_config, can be used to override the config settings at build time:

```
load("//pico:defs.bzl", "pico_add_uf2_output")

pico_build_with_config(
    name = "hello_usb.elf",
    input = "hello.elf",
    stdio_uart = False,
    stdio_usb = True,
)
```


