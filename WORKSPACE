workspace(name = "rules_pico")

load("//pico:repositories.bzl", "rules_pico_dependencies", "rules_pico_toolchains")

rules_pico_dependencies()
rules_pico_toolchains();

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("//toolchain/private:defs.bzl", "detect_gcc_toolchain")

detect_gcc_toolchain(
    name = "gcc-arm-embedded",
)
