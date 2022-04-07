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
        "@koro-platforms//cxx:14",
    ],
)
