load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def rules_pico_dependencies():
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
        ],
    )

    # Fetch pico-sdk via git so that we can pull in the tinyusb submodule
    maybe(
        new_git_repository,
        name = "pico-sdk",
        build_file = "@rules_pico//pico:pico-sdk.BUILD",
        tag = "1.3.0",
        remote = "https://github.com/raspberrypi/pico-sdk.git",
        init_submodules = True,
    )

    maybe(
        http_archive,
        name = "pico-examples",
        build_file = "@rules_pico//pico:pico-examples.BUILD",
        urls = [
            "https://github.com/raspberrypi/pico-examples/archive/refs/tags/sdk-1.3.0.tar.gz",
        ],
        strip_prefix = "pico-examples-sdk-1.3.0",
        sha256 = "4e2f8b14f97bb0070dff2e94cbdec83d5cef8ff4c3069d024869b7229c6126f1",
    )

def rules_pico_toolchains():
    native.register_toolchains("//toolchain:gcc-arm-embedded")
