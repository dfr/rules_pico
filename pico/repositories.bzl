load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_pico_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        # `main` as of 2021-10-27
        # Release request: https://github.com/bazelbuild/bazel-skylib/issues/336
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/archive/6e30a77347071ab22ce346b6d20cf8912919f644.zip",
        ],
        strip_prefix = "bazel-skylib-6e30a77347071ab22ce346b6d20cf8912919f644",
        sha256 = "247361e64b2a85b40cb45b9c071e42433467c6c87546270cbe2672eb9f317b5a",
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
