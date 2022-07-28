load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

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

def _format_flag_string_value_impl(ctx):
    if ctx.attr.quote:
        fmt = "{}=\"{}\""
    else:
        fmt = "{}={}"
    return CcInfo(
        compilation_context = cc_common.create_compilation_context(
            defines = depset([
                fmt.format(
                    ctx.attr.flag_name,
                    ctx.attr.flag_value[BuildSettingInfo].value,
                ),
            ]),
        ),
    )

format_flag_string_value = rule(
    implementation = _format_flag_string_value_impl,
    attrs = {
        "flag_name": attr.string(),
        "flag_value": attr.label(),
        "quote": attr.bool(default=True),
    },
)

_TEMPLATE = """\
#include "boards/{}.h"
#include "cmsis/rename_exceptions.h"
"""

def _config_autogen_impl(ctx):
    ctx.actions.write(
        output = ctx.outputs.output,
        content = _TEMPLATE.format(ctx.attr.board[BuildSettingInfo].value),
    )

config_autogen = rule(
    implementation = _config_autogen_impl,
    attrs = {
        "board": attr.label(mandatory = True),
        "output": attr.output(mandatory = True),
    },
)
