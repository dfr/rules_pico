workspace(name = "rules_pico")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//pico:repositories.bzl", "rules_pico_dependencies", "rules_pico_toolchains")

rules_pico_dependencies()
rules_pico_toolchains();

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "pico-examples",
    build_file = "@rules_pico//pico:BUILD.pico-examples",
    urls = [
        "https://github.com/raspberrypi/pico-examples/archive/refs/tags/sdk-1.3.1.tar.gz",
    ],
    strip_prefix = "pico-examples-sdk-1.3.1",
    sha256 = "b8a0a05cf0d822acf674ddac11bff88aa21e724471e0f972aabae09f01731c80",
)
