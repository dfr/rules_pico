workspace(name = "rules_pico")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//pico:repositories.bzl", "rules_pico_dependencies", "rules_pico_toolchains")

rules_pico_dependencies()
rules_pico_toolchains();

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()


http_archive(
    name = "pico-examples",
    build_file = "@rules_pico//pico:pico-examples.BUILD",
    urls = [
        "https://github.com/raspberrypi/pico-examples/archive/refs/tags/sdk-1.3.0.tar.gz",
    ],
    strip_prefix = "pico-examples-sdk-1.3.0",
    sha256 = "4e2f8b14f97bb0070dff2e94cbdec83d5cef8ff4c3069d024869b7229c6126f1",
)
