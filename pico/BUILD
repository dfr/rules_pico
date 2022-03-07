load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

cmake(
    name = "pico",
    build_args = [
        #"-v",
        "-j 8",
    ],
    cache_entries = {
        "CMAKE_SYSTEM_NAME": "PICO",
    },
    env = {
        "PICO_SDK_PATH": "$(execpath @pico-sdk//:top)",
        "PICO_TOOLCHAIN_PATH": "/usr/local/gcc-arm-embedded",
    },
    build_data = [
        "@pico-sdk//:top",
    ],
    generate_crosstool_file = False,
    lib_source = "//pico/cmake:all_srcs",
    out_data_dirs = ["data"],
    out_static_libs = [
        "libpico_stdlib.a",
        "libhardware_spi.a",
    ],
    visibility = ["//visibility:public"],
)

