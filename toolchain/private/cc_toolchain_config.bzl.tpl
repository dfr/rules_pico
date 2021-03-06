# -*- bazel-starlark -*-

load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
    "with_feature_set",
)
load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

all_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.lto_backend,
]

all_cpp_compile_actions = [
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
]

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

def _tool(ctx, tool_name):
    return "{gccpath}/bin/arm-none-eabi-{}".format(tool_name)

def _impl(ctx):
    default_link_flags_feature = feature(
        name = "default_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            #"--verbose",
                            "-lstdc++",
                            "-lm",
                        ],
                    ),
                ],
            ),
        ],
    )

    unfiltered_compile_flags_feature = feature(
        name = "unfiltered_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                        ],
                    ),
                ],
            ),
        ],
    )

    supports_pic_feature = feature(name = "supports_pic", enabled = True)

    flag_sets = [
        flag_set(
            actions = all_compile_actions,
            flag_groups = [
                flag_group(
                    flags = [
                        "-U_FORTIFY_SOURCE",
                        "-D_FORTIFY_SOURCE=1",
                        "-DFREESTANDING",
                        "-fstack-protector",
                        "-Wall",
                        "-fno-omit-frame-pointer",
                        # "-isystem {gccpath}/arm-none-eabi/include",
                        ] + ctx.attr.copts,
                ),
            ],
        ),
        flag_set(
            actions = all_compile_actions,
            flag_groups = [flag_group(flags = ["-g"])],
            with_features = [with_feature_set(features = ["dbg"])],
        ),
        flag_set(
            actions = all_compile_actions,
            flag_groups = [
                flag_group(
                    flags = [
                        "-g",
                        "-O2",
                        "-DNDEBUG",
                        "-ffunction-sections",
                        "-fdata-sections",
                    ],
                ),
            ],
            with_features = [with_feature_set(features = ["opt"])],
        ),
    ]
    if ctx.attr.cxxopts:
        flag_sets.append(
            flag_set(
                actions = all_cpp_compile_actions + [ACTION_NAMES.lto_backend],
                flag_groups = [flag_group(flags = [] + ctx.attr.cxxopts)],
            )
        )

    default_compile_flags_feature = feature(
        name = "default_compile_flags",
        enabled = True,
        flag_sets = flag_sets,
    )

    opt_feature = feature(name = "opt")

    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)

    objcopy_embed_flags_feature = feature(
        name = "objcopy_embed_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ["objcopy_embed_data"],
                flag_groups = [flag_group(flags = ["-I", "binary"])],
            ),
        ],
    )

    dbg_feature = feature(name = "dbg")

    user_compile_flags_feature = feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                        expand_if_available = "user_compile_flags",
                    ),
                ],
            ),
        ],
    )

    tool_paths = [
        tool_path(
            name = "gcc",
            path = _tool(ctx, "gcc"),
        ),
        tool_path(
            name = "ld",
            path = _tool(ctx, "ld"),
        ),
        tool_path(
            name = "ar",
            path = _tool(ctx, "ar"),
        ),
        tool_path(
            name = "cpp",
            path = _tool(ctx, "cpp"),
        ),
        tool_path(
            name = "gcov",
            path = _tool(ctx, "gcov"),
        ),
        tool_path(
            name = "nm",
            path = _tool(ctx, "nm"),
        ),
        tool_path(
            name = "objcopy",
            path = _tool(ctx, "objcopy"),
        ),
        tool_path(
            name = "objdump",
            path = _tool(ctx, "objdump"),
        ),
        tool_path(
            name = "strip",
            path = _tool(ctx, "strip"),
        ),
    ]
    features = [
        default_compile_flags_feature,
        default_link_flags_feature,
        objcopy_embed_flags_feature,
        opt_feature,
        dbg_feature,
        user_compile_flags_feature,
        #sysroot_feature,
        unfiltered_compile_flags_feature,
    ]
    cxx_builtin_include_directories = [
        "{gccpath}/arm-none-eabi/include",
        "{gccpath}/lib/gcc/arm-none-eabi/{gccver}/include",
        "{gccpath}/lib/gcc/arm-none-eabi/{gccver}/include-fixed",
        "{gccpath}/include/newlib",
    ]
    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        toolchain_identifier = "gcc-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "local",
        target_libc = "local",
        compiler = "gcc",
        abi_version = "local",
        abi_libc_version = "local",
        tool_paths = tool_paths,
        cxx_builtin_include_directories = cxx_builtin_include_directories,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "copts": attr.string_list(default = []),
        "cxxopts": attr.string_list(default = []),
    },
    provides = [CcToolchainConfigInfo],
)
