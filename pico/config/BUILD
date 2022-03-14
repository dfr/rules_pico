load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

package(default_visibility = ["@pico-sdk//:__pkg__"])

string_flag(
    name = "board",
    build_setting_default = "pico",
    values = [
        "pico",
        "vgaboard",
    ],
)

label_flag(
    name = "double_impl",
    build_setting_default = "@pico-sdk//:pico_double_pico",
)

label_flag(
    name = "float_impl",
    build_setting_default = "@pico-sdk//:pico_float_pico",
)

bool_flag(
    name = "stdio_uart",
    build_setting_default = True,
)

bool_flag(
    name = "stdio_usb",
    build_setting_default = False,
)

bool_flag(
    name = "stdio_semihosting",
    build_setting_default = False,
)
