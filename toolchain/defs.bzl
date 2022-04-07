load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")
load("@gcc-arm-embedded//:cc_toolchain_config.bzl", "cc_toolchain_config")

def gcc_embedded_toolchain(*, name, copts, cxxopts = None, target_compatible_with):
    cc_toolchain_config(
        name = "{}-config".format(name),
        copts = copts,
        cxxopts = cxxopts,
    )
    cc_toolchain(
        name = "{}-toolchain".format(name),
        all_files = "@rules_pico//toolchain:empty",
        compiler_files = "@rules_pico//toolchain:empty",
        dwp_files = "@rules_pico//toolchain:empty",
        linker_files = "@rules_pico//toolchain:empty",
        objcopy_files = "@rules_pico//toolchain:empty",
        strip_files = "@rules_pico//toolchain:empty",
        supports_param_files = 0,
        toolchain_config = ":{}-config".format(name),
    )
    native.toolchain(
        name = name,
        exec_compatible_with = HOST_CONSTRAINTS,
        target_compatible_with = target_compatible_with,
        toolchain = ":{}-toolchain".format(name),
        toolchain_type = "@rules_cc//cc:toolchain_type",
    )
