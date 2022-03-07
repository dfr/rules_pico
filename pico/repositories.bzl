load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_pico_dependencies():
    maybe(
        http_archive,
        name = "rules_foreign_cc",
        strip_prefix = "rules_foreign_cc-0.7.0",
        url = "https://github.com/bazelbuild/rules_foreign_cc/archive/0.7.0.tar.gz",
    )
    native.new_local_repository(
        name = "pico-sdk",
        path = "/projects/rpi/pico/pico-sdk",
        build_file = "@rules_pico//pico:pico-sdk.BUILD",
    )
    native.new_local_repository(
        name = "pico-examples",
        path = "/projects/rpi/pico/pico-examples",
        build_file = "@rules_pico//pico:pico-examples.BUILD",
    )

def rules_pico_toolchains():
    native.register_toolchains("//toolchain:gcc-arm-embedded")
