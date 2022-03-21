def pico_sdk_library(
        *,
        name,
        srcdir = None,
        incdir = None,
        hdrs = [],
        defines = [],
        deps = [],
        target_compatible_with = None,
        visibility = ["//visibility:public"],
        alwayslink = None):
    native.cc_library(
        name = name,
        srcs = native.glob([
            srcdir + "/*.c",
            srcdir + "/*.S",
        ], allow_empty = True) if srcdir else [],
        hdrs = native.glob([
            incdir + "/*.h",
            incdir + "/*.S",
            incdir + "/**/*.h",
            incdir + "/**/*.S",
        ]) + hdrs if incdir else hdrs,
        defines = defines + ["LIB_" + name.upper()],
        deps = deps,
        strip_include_prefix = incdir,
        target_compatible_with = target_compatible_with,
        visibility = visibility,
        alwayslink = alwayslink,
    )


def pico_simple_hardware_target(*, name, deps = [], visibility = ["//visibility:public"]):
    pico_sdk_library(
        name = name,
        srcdir = "src/rp2_common/" + name,
        incdir = "src/rp2_common/" + name + "/include",
        deps = [
            ":{}_headers".format(name),
        ] + deps,
        visibility = visibility,
    )

    pico_sdk_library(
        name = name + "_headers",
        incdir = "src/rp2_common/" + name + "/include",
        deps = [
            ":pico_base",
            ":pico_platform",
            ":hardware_structs",
        ],
    )
