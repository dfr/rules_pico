load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

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

def pico_binary(*, name, srcs, deps, copts = None):
    "Build an ELF binary using the pico-sdk bootstrap and memory map"
    native.cc_binary(
        name = name,
        srcs = srcs + [
            "@pico-sdk//:bs2_default_padded_checksummed.S",
        ],
        linkopts = ["-Wl,--wrap={}".format(fn) for fn in WRAP_FUNCTIONS] + [
            "-mcpu=cortex-m0plus",
            "-mthumb",
            "--specs=nosys.specs",
            #"-Wl,-Map=foo.map",
            "-Wl,--gc-sections",
            "-Wl,-z,max-page-size=4096",
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

def _pico_add_uf2_output_impl(ctx):
    elf = ctx.executable.input
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        inputs = [elf],
        outputs = [out],
        executable = ctx.executable.elf2uf2,
        arguments = [elf.path, out.path],
    )
    return [DefaultInfo(
        files = depset(direct = [out]),
    )]

pico_add_uf2_output = rule(
    implementation = _pico_add_uf2_output_impl,
    doc = "Convert an ELF format binary to UF2",
    attrs = {
        "input": attr.label(
            doc = "Input ELF file",
            cfg = "target",
            executable = True,
            mandatory = True,
        ),
        "elf2uf2": attr.label(
            doc = "elf2uf2 conversion tool",
            cfg = "host",
            default = "@pico-sdk//:elf2uf2",
            executable = True,
        ),
    },
)

def _pico_pio_header_impl(ctx):
    pio = ctx.file.input
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        inputs = [pio],
        outputs = [out],
        executable = ctx.executable.pioasm,
        arguments = [pio.path, out.path],
    )
    return [DefaultInfo(
        files = depset(direct = [out]),
    )]

pico_pio_header = rule(
    implementation = _pico_pio_header_impl,
    doc = "Assemble a file containing pio programs",
    attrs = {
        "input": attr.label(
            doc = "Input pio file",
            mandatory = True,
            allow_single_file = True,
        ),
        "pioasm": attr.label(
            doc = "pioasm tool",
            cfg = "host",
            default = "@pico-sdk//:pioasm",
            executable = True,
        ),
    },
)

def _pico_add_bin_output_impl(ctx):
    toolchain = find_cpp_toolchain(ctx)
    elf = ctx.executable.input
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run(
        inputs = [elf],
        outputs = [out],
        executable = toolchain.objcopy_executable,
        arguments = ["-Obinary", elf.path, out.path],
    )
    return [DefaultInfo(
        files = depset(direct = [out]),
    )]

pico_add_bin_output = rule(
    implementation = _pico_add_bin_output_impl,
    doc = "Convert an ELF format binary to BIN",
    fragments = ["cpp"],
    attrs = {
        "input": attr.label(
            doc = "Input ELF file",
            cfg = "target",
            executable = True,
            mandatory = True,
        ),
    },
    toolchains = [
        "@bazel_tools//tools/cpp:toolchain_type",
    ],
)

def _pico_add_map_output_impl(ctx):
    toolchain = find_cpp_toolchain(ctx)
    elf = ctx.executable.input
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
        inputs = [elf],
        outputs = [out],
        command = "{} -C --all-headers {} > {}".format(
            toolchain.objdump_executable,
            elf.path,
            out.path),
    )
    return [DefaultInfo(
        files = depset(direct = [out]),
    )]

pico_add_map_output = rule(
    implementation = _pico_add_map_output_impl,
    doc = "Generate a map file from an an ELF format binary",
    fragments = ["cpp"],
    attrs = {
        "input": attr.label(
            doc = "Input ELF file",
            cfg = "target",
            executable = True,
            mandatory = True,
        ),
    },
    toolchains = [
        "@bazel_tools//tools/cpp:toolchain_type",
    ],
)

# attr is the attributes from pico_stdio_binary below
def _config_override_impl(settings, attr):
    return {
        "@rules_pico//pico/config:stdio_uart": attr.stdio_uart,
        "@rules_pico//pico/config:stdio_usb": attr.stdio_usb,
        "@rules_pico//pico/config:stdio_semihosting": attr.stdio_semihosting,
    }

config_override = transition(
    implementation = _config_override_impl,
    inputs = [],
    outputs = [
        "@rules_pico//pico/config:stdio_uart",
        "@rules_pico//pico/config:stdio_usb",
        "@rules_pico//pico/config:stdio_semihosting",
    ],
)

# creates a symlink to the binary build with the selected stdio options
def _pico_build_with_config_impl(ctx):
    elf = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(
        output = elf,
        target_file = ctx.executable.input,
        is_executable = True,
    )
    return [DefaultInfo(
        executable = elf,
        files = depset(direct = [elf]),
    )]

pico_build_with_config = rule(
    implementation = _pico_build_with_config_impl,
    doc = "Build an input target with specified config overrides and create a symlink to the result",
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "stdio_uart": attr.bool(
            doc = "Set to true to enable stdio output over UART",
            default = True,
        ),
        "stdio_usb": attr.bool(
            doc = "Set to true to enable stdio output over USB",
            default = False,
        ),
        "stdio_semihosting": attr.bool(
            doc = "Set to true to enable stdio output via debugger",
            default = False,
        ),
        "input": attr.label(
            cfg = config_override,
            executable = True,
            mandatory = True,
        ),
    },
    executable = True,
)
