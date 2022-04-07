load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")
load("//toolchain/private:defs.bzl", "gcc_arm_embedded_toolchain")

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
        build_file = "@rules_pico//pico:BUILD.pico-sdk",
        #tag = "1.3.0",
        #remote = "https://github.com/raspberrypi/pico-sdk.git",
        tag = "1.3.0-dfr",
        remote = "https://github.com/dfr/pico-sdk.git",
        init_submodules = True,
    )

    maybe(
        gcc_arm_embedded_toolchain,
        name = "gcc-arm-embedded",
    )

def rules_pico_toolchains():
    native.register_toolchains("//toolchain:gcc-pico")
