load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//toolchain/private:defs.bzl", "gcc_arm_embedded_toolchain")

def rules_pico_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
        ],
        sha256 = "af87959afe497dc8dfd4c6cb66e1279cb98ccc84284619ebfec27d9c09a903de",
    )

    maybe(
        http_archive,
        name = "koro-platforms",
        url = "https://github.com/dfr/koro-platforms/archive/refs/heads/main.zip",
        strip_prefix = "koro-platforms-main",
        sha256 = "7e43bfc83053442ed434739ff492978e339953bec1cf829b96845a6ae2b43c83",
    )

    maybe(
        http_archive,
        name = "tinyusb",
        build_file = "@rules_pico//pico:BUILD.tinyusb",
        url = "https://github.com/hathach/tinyusb/archive/refs/tags/0.12.0.zip",
        strip_prefix = "tinyusb-0.12.0",
        sha256 = "9d4eb47d231a39fc79f6b55e96f19e3c85c520b13dea7eb2f5dc4ed378fa317a",
    )

    # Fetch pico-sdk via git so that we can pull in the tinyusb submodule
    maybe(
        http_archive,
        name = "pico-sdk",
        build_file = "@rules_pico//pico:BUILD.pico-sdk",
        url = "https://github.com/dfr/pico-sdk/archive/refs/tags/1.3.0-dfr.zip",
        strip_prefix = "pico-sdk-1.3.0-dfr",
        sha256 = "0931e3dfe28d2efb38261539f04fc256e9f18b64f571f3e482fa1412f2c2ff92",
    )

    maybe(
        gcc_arm_embedded_toolchain,
        name = "gcc-arm-embedded",
    )

def rules_pico_toolchains():
    native.register_toolchains("//toolchain:gcc-pico")
