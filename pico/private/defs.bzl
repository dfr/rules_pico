def pico_sdk_library(
        *,
        name,
        srcdir = None,
        incdir = None,
        srcs = [],
        hdrs = [],
        defines = [],
        **kwargs):
    if srcdir:
        srcs = native.glob([
            srcdir + "/*.c",
            srcdir + "/*.S",
        ], allow_empty = True) + srcs
    if incdir:
        hdrs = native.glob([
            incdir + "/*.h",
            incdir + "/*.S",
            incdir + "/**/*.h",
            incdir + "/**/*.S",
        ]) + hdrs
        kwargs["strip_include_prefix"] = incdir
    native.cc_library(
        name = name,
        srcs = srcs,
        hdrs = hdrs,
        defines = defines + ["LIB_" + name.upper()],
        **kwargs,
    )

def pico_simple_hardware_target(*, name, deps = [], **kwargs):
    pico_sdk_library(
        name = name,
        srcdir = "src/rp2_common/" + name,
        incdir = "src/rp2_common/" + name + "/include",
        deps = [
            ":{}_headers".format(name),
        ] + deps,
        **kwargs,
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
