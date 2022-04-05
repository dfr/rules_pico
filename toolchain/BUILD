load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

filegroup(name = "empty")

cc_toolchain_config(
    name = "gcc-arm-embedded-config",
    copts = [
        "-mcpu=cortex-m0plus",
        "-mthumb",
    ],
)

cc_toolchain(
    name = "gcc-arm-embedded-toolchain",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":gcc-arm-embedded-config",
)

toolchain(
    name = "gcc-arm-embedded",
    exec_compatible_with = HOST_CONSTRAINTS,
    target_compatible_with = [
        "@platforms//os:none",
        "@platforms//cpu:armv6-m",
    ],
    toolchain = ":gcc-arm-embedded-toolchain",
    toolchain_type = "@rules_cc//cc:toolchain_type",
)
