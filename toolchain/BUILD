load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")
load("@gcc-arm-embedded//:cc_toolchain_config.bzl", "cc_toolchain_config")
load(":defs.bzl", "gcc_embedded_toolchain")

package(default_visibility = ["//visibility:public"])

filegroup(name = "empty")

gcc_embedded_toolchain(
    name = "gcc-pico",
    copts = [
        "-mcpu=cortex-m0plus",
        "-mthumb",
    ],
    target_compatible_with = [
        "@platforms//os:none",
        "@platforms//cpu:armv6-m",
    ],
)
