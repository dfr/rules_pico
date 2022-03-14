load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

cc_library(
    name = "pico",
    visibility = ["//visibility:public"],
    deps = ["pico_bazel"],
)

cmake(
    name = "pico_cmake",
    build_args = [
        #"-v",
        "-j 8",
    ],
    build_data = [
        "@pico-sdk//:top",
    ],
    cache_entries = {
        "CMAKE_SYSTEM_NAME": "PICO",
    },
    env = {
        "PICO_SDK_PATH": "$(execpath @pico-sdk//:top)",
        "PICO_TOOLCHAIN_PATH": "/usr/local/gcc-arm-embedded",
    },
    generate_crosstool_file = False,
    lib_source = "//pico/cmake:all_srcs",
    out_data_dirs = ["data"],
    out_static_libs = [
        "libpico_stdlib.a",
        "libhardware_spi.a",
    ],
)

cc_library(
    name = "pico_bazel",
    deps = [
        "@pico-sdk//:hardware_spi",
        "@pico-sdk//:pico_stdlib",
    ],
)
