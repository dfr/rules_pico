load("//pico:defs.bzl", "pico_elf_binary", "pico_stdio_elf_binary", "pico_uf2_binary")

pico_elf_binary(
    name = "hello.elf",
    srcs = [
        "@pico-examples//:hello_world/serial/hello_serial.c",
    ],
    deps = [
        "//pico:pico",
    ],
)

pico_stdio_elf_binary(
    name = "hello_serial.elf",
    executable = ":hello.elf",
    uart = True,
    usb = False,
)

pico_uf2_binary(
    name = "hello_serial.uf2",
    elf = "hello_serial.elf",
)

pico_stdio_elf_binary(
    name = "hello_usb.elf",
    executable = ":hello.elf",
    uart = False,
    usb = True,
)

pico_uf2_binary(
    name = "hello_usb.uf2",
    elf = "hello_usb.elf",
)
