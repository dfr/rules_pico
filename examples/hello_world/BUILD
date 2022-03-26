load("//pico:defs.bzl", "pico_binary")
load("//pico:defs.bzl", "pico_build_with_config")
load("//pico:defs.bzl", "pico_add_bin_output")
load("//pico:defs.bzl", "pico_add_map_output")
load("//pico:defs.bzl", "pico_add_uf2_output")

pico_binary(
    name = "hello.elf",
    srcs = [
        "@pico-examples//:hello_world/serial/hello_serial.c",
    ],
    deps = [
        "//pico:pico_stdlib",
    ],
)

pico_build_with_config(
    name = "hello_serial.elf",
    input = "hello.elf",
    stdio_uart = True,
    stdio_usb = False,
)

pico_add_uf2_output(
    name = "hello_serial.uf2",
    input = "hello_serial.elf",
)

pico_build_with_config(
    name = "hello_usb.elf",
    input = "hello.elf",
    stdio_uart = False,
    stdio_usb = True,
)

pico_add_uf2_output(
    name = "hello_usb.uf2",
    input = "hello_usb.elf",
)
