load("@bazel_skylib//rules:common_settings.bzl", "bool_flag", "string_flag")

package(default_visibility = ["@pico-sdk//:__pkg__"])

string_flag(
    name = "board",
    build_setting_default = "pico",
    values = [
        "adafruit_feather_rp2040",
        "adafruit_itsybitsy_rp2040",
        "adafruit_kb2040",
        "adafruit_macropad_rp2040",
        "adafruit_qtpy_rp2040",
        "adafruit_trinkey_qt2040",
        "arduino_nano_rp2040_connect",
        "datanoisetv_rp2040_dsp",
        "eetree_gamekit_rp2040",
        "garatronic_pybstick26_rp2040",
        "melopero_shake_rp2040",
        "none",
        "pico",
        "pico_w",
        "pimoroni_badger2040",
        "pimoroni_interstate75",
        "pimoroni_keybow2040",
        "pimoroni_motor2040",
        "pimoroni_pga2040",
        "pimoroni_picolipo_16mb",
        "pimoroni_picolipo_4mb",
        "pimoroni_picosystem",
        "pimoroni_plasma2040",
        "pimoroni_servo2040",
        "pimoroni_tiny2040",
        "pimoroni_tiny2040_2mb",
        "pybstick26_rp2040",
        "seeed_xiao_rp2040",
        "solderparty_rp2040_stamp_carrier",
        "solderparty_rp2040_stamp_round_carrier",
        "solderparty_rp2040_stamp",
        "sparkfun_micromod",
        "sparkfun_promicro",
        "sparkfun_thingplus",
        "vgaboard",
        "waveshare_rp2040_lcd_0.96",
        "waveshare_rp2040_plus_16mb",
        "waveshare_rp2040_plus_4mb",
        "waveshare_rp2040_zero",
        "wiznet_w5100s_evb_pico"
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

bool_flag(
    name = "rtos_adapter_enable",
    build_setting_default = False,
)

label_flag(
    name = "rtos_adapter_header",
    build_setting_default = "@//:please-set-the-rtos_adapter_header-and-rtos_adapter_header_name-flags",
)

string_flag(
    name = "rtos_adapter_header_name",
    build_setting_default = "",
)