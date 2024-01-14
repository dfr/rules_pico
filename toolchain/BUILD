load("@arm_none_eabi//toolchain:toolchain.bzl", "arm_none_eabi_toolchain")

package(default_visibility = ["//visibility:public"])

arm_none_eabi_toolchain(
    name = "gcc-pico",
    copts = [
        "-mcpu=cortex-m0plus",
        "-mthumb",
    ],
    target_compatible_with = [
        "@platforms//os:none",
        "@platforms//cpu:armv6-m",
        "@koro-platforms//cxx:14",
    ],
)
