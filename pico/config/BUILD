load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

package(default_visibility = ["@pico-sdk//:__pkg__"])

string_flag(
    name = "board",
    build_setting_default = "pico",
    values = [
        "adafruit_feather_rp2040",
        "adafruit_itsybitsy_rp2040",
        "adafruit_qtpy_rp2040",
        "adafruit_trinkey_qt2040",
        "arduino_nano_rp2040_connect",
        "melopero_shake_rp2040",
        "none",
        "pico",
        "pimoroni_interstate75",
        "pimoroni_keybow2040",
        "pimoroni_pga2040",
        "pimoroni_picolipo_16mb",
        "pimoroni_picolipo_4mb",
        "pimoroni_picosystem",
        "pimoroni_plasma2040",
        "pimoroni_tiny2040",
        "pybstick26_rp2040",
        "sparkfun_micromod",
        "sparkfun_promicro",
        "sparkfun_thingplus",
        "vgaboard",
        "waveshare_rp2040_lcd_0.96",
        "waveshare_rp2040_plus_16mb",
        "waveshare_rp2040_plus_4mb",
        "waveshare_rp2040_zero",
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
