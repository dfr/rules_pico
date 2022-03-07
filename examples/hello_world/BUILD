load("//pico:defs.bzl", "pico_binary")

pico_binary(
    name = "hello_serial",
    srcs = [
        "@pico-examples//:hello_world/serial/hello_serial.c",
    ],
    deps = [
        "//pico:pico",
    ],
)

pico_binary(
    name = "hello_usb",
    srcs = [
        "@pico-examples//:hello_world/usb/hello_usb.c",
    ],
    deps = [
        "//pico:pico",
    ],
)
