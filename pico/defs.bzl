load("@rules_cc//cc:toolchain_utils.bzl", "find_cpp_toolchain")

WRAP_FUNCTIONS = [
    "__aeabi_cdcmpeq",
    "__aeabi_cdcmple",
    "__aeabi_cdrcmple",
    "__aeabi_cfcmpeq",
    "__aeabi_cfcmple",
    "__aeabi_cfrcmple",
    "__aeabi_d2f",
    "__aeabi_d2iz",
    "__aeabi_d2lz",
    "__aeabi_d2uiz",
    "__aeabi_d2ulz",
    "__aeabi_dadd",
    "__aeabi_dcmpeq",
    "__aeabi_dcmpge",
    "__aeabi_dcmpgt",
    "__aeabi_dcmple",
    "__aeabi_dcmplt",
    "__aeabi_dcmpun",
    "__aeabi_ddiv",
    "__aeabi_dmul",
    "__aeabi_drsub",
    "__aeabi_dsub",
    "__aeabi_f2d",
    "__aeabi_f2iz",
    "__aeabi_f2lz",
    "__aeabi_f2uiz",
    "__aeabi_f2ulz",
    "__aeabi_fadd",
    "__aeabi_fcmpeq",
    "__aeabi_fcmpge",
    "__aeabi_fcmpgt",
    "__aeabi_fcmple",
    "__aeabi_fcmplt",
    "__aeabi_fcmpun",
    "__aeabi_fdiv",
    "__aeabi_fmul",
    "__aeabi_frsub",
    "__aeabi_fsub",
    "__aeabi_i2d",
    "__aeabi_i2f",
    "__aeabi_idiv",
    "__aeabi_idivmod",
    "__aeabi_l2d",
    "__aeabi_l2f",
    "__aeabi_ldivmod",
    "__aeabi_lmul",
    "__aeabi_memcpy",
    "__aeabi_memcpy4",
    "__aeabi_memcpy8",
    "__aeabi_memset",
    "__aeabi_memset4",
    "__aeabi_memset8",
    "__aeabi_ui2d",
    "__aeabi_ui2f",
    "__aeabi_uidiv",
    "__aeabi_uidivmod",
    "__aeabi_ul2d",
    "__aeabi_ul2f",
    "__aeabi_uldivmod",
    "__clz",
    "__clzdi2",
    "__clzl",
    "__clzll",
    "__clzsi2",
    "__ctzdi2",
    "__ctzsi2",
    "__popcountdi2",
    "__popcountsi2",
    "acos",
    "acosf",
    "acosh",
    "acoshf",
    "asin",
    "asinf",
    "asinh",
    "asinhf",
    "atan",
    "atan2",
    "atan2f",
    "atanf",
    "atanh",
    "atanhf",
    "calloc",
    "cbrt",
    "cbrtf",
    "ceil",
    "ceilf",
    "copysign",
    "copysignf",
    "cos",
    "cosf",
    "cosh",
    "coshf",
    "drem",
    "dremf",
    "exp",
    "exp10",
    "exp10f",
    "exp2",
    "exp2f",
    "expf",
    "expm1",
    "expm1f",
    "floor",
    "floorf",
    "fma",
    "fmaf",
    "fmod",
    "fmodf",
    "free",
    "getchar",
    "gnu",
    "hypot",
    "hypotf",
    "ldexp",
    "ldexpf",
    "log",
    "log10",
    "log10f",
    "log1p",
    "log1pf",
    "log2",
    "log2f",
    "logf",
    "malloc",
    "memcpy",
    "memset",
    "pow",
    "powf",
    "printf",
    "putchar",
    "puts",
    "remainder",
    "remainderf",
    "remquo",
    "remquof",
    "round",
    "roundf",
    "sin",
    "sinf",
    "sinh",
    "sinhf",
    "snprintf",
    "sprintf",
    "sqrt",
    "sqrtf",
    "tan",
    "tanf",
    "tanh",
    "tanhf",
    "trunc",
    "truncf",
    "vprintf",
    "vsnprintf",
]

def pico_elf_binary(*, name, srcs, deps, copts = None):
    native.cc_binary(
        name = name,
        srcs = srcs + [
            "@pico-sdk//:bs2_default_padded_checksummed.S",
        ],
        linkopts = ["-Wl,--wrap={}".format(fn) for fn in WRAP_FUNCTIONS] + [
            "-mcpu=cortex-m0plus",
            "-mthumb",
            "--specs=nosys.specs",
            "-Wl,--gc-sections",
            "-Wl,--script=$(rootpath @pico-sdk//:src/rp2_common/pico_standard_link/memmap_default.ld)",
        ],
        target_compatible_with = [
            "@platforms//os:none",
            "@platforms//cpu:armv6-m",
        ],
        deps = deps + [
            "@pico-sdk//:src/rp2_common/pico_standard_link/memmap_default.ld",
        ],
        copts = copts,
    )

# creates a symlink to the binary build with the selected stdio options
def _uf2_binary_impl(ctx):
    elf = ctx.executable.elf
    uf2 = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        inputs = [elf],
        outputs = [uf2],
        executable = ctx.executable.elf2uf2,
        arguments = [elf.path, uf2.path],
    )
    return [DefaultInfo(
        files = depset(direct = [uf2]),
    )]

pico_uf2_binary = rule(
    implementation = _uf2_binary_impl,
    attrs = {
        "elf": attr.label(
            cfg = "target",
            executable = True,
            mandatory = True,
        ),
        "elf2uf2": attr.label(
            cfg = "host",
            default = "@pico-sdk//:elf2uf2",
            executable = True,
        ),
    },
)

def pico_binary(*, name, srcs, deps, copts):
    "A macro which generates an ELF binary and converts it to UF2"
    pico_elf_binary(
        name = name + ".elf",
        srcs = srcs,
        deps = deps,
        copts = copts,
    )
    pico_uf2_binary(
        name = name + ".uf2",
        elf = name + ".elf",
    )

# attr is the attributes from pico_stdio_binary below
def _stdio_transition_impl(settings, attr):
    return {
        "@rules_pico//pico/config:stdio_uart": attr.uart,
        "@rules_pico//pico/config:stdio_usb": attr.usb,
    }

stdio_transition = transition(
    implementation = _stdio_transition_impl,
    inputs = [],
    outputs = [
        "@rules_pico//pico/config:stdio_uart",
        "@rules_pico//pico/config:stdio_usb",
    ],
)

# creates a symlink to the binary build with the selected stdio options
def _stdio_binary_impl(ctx):
    elf = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(
        output = elf,
        target_file = ctx.executable.executable,
        is_executable = True,
    )
    return [DefaultInfo(
        executable = elf,
        files = depset(direct = [elf]),
    )]

pico_stdio_elf_binary = rule(
    implementation = _stdio_binary_impl,
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "uart": attr.bool(),
        "usb": attr.bool(),
        "executable": attr.label(
            cfg = "target",
            executable = True,
            mandatory = True,
        ),
    },
    cfg = stdio_transition,
    executable = True,
)
