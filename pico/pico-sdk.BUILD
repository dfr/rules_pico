# -*- bazel-build -*-

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "top",
    srcs = ["."],
    visibility = ["//visibility:public"],
)

exports_files(
    glob(["src/**"]),
)

cc_binary(
    name = "elf2uf2",
    srcs = [
        "tools/elf2uf2/main.cpp",
        "tools/elf2uf2/elf.h",
    ],
    deps = [
        ":boot_uf2",
    ],
    target_compatible_with = select({
        "@platforms//os:freebsd": [],
        "@platforms//os:osx": [],
        "@platforms//os:linux": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
    visibility = ["//visibility:public"],
)

genrule(
    name = "bs2_default_padded_checksummed",
    srcs = [":bs2_default_bin"],
    outs = ["bs2_default_padded_checksummed.S"],
    cmd = "$(location :pad_checksum) -s 0xffffffff $< $@",
    tools = [":pad_checksum"],
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "pad_checksum",
    srcs = ["src/rp2_common/boot_stage2/pad_checksum"],
)

genrule(
    name = "bs2_default_bin",
    srcs = [":bs2_default.elf"],
    outs = ["bs2_default.bin"],
    cmd = "$(OBJCOPY) -O binary $< $@",
    toolchains = ["@bazel_tools//tools/cpp:current_cc_toolchain"],
)

cc_binary(
    name = "bs2_default.elf",
    srcs = [
        "src/rp2_common/boot_stage2/compile_time_choice.S",
    ],
    linkopts = [
        "--specs=nosys.specs",
        "-nostartfiles",
        "-Wl,--script=$(rootpath src/rp2_common/boot_stage2/boot_stage2.ld)",
    ],
    deps = [
        "src/rp2_common/boot_stage2/boot_stage2.ld",
        ":boot_stage2_asm",
        ":boot_stage2_h",
        ":config_autogen_h",
        ":pico_base_h",
        ":pico_platform_h",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "boot_uf2",
    hdrs = glob(["src/common/boot_uf2/include/boot/*.h"]),
    strip_include_prefix = "src/common/boot_uf2/include",
)

cc_library(
    name = "boot_stage2_asm",
    hdrs = glob(["src/rp2_common/boot_stage2/*.S"]),
    strip_include_prefix = "src/rp2_common/boot_stage2",
    deps = [":boot_stage2_asminclude"],
)

cc_library(
    name = "boot_stage2_asminclude",
    hdrs = glob(["src/rp2_common/boot_stage2/asminclude/boot2_helpers/*.S"]),
    strip_include_prefix = "src/rp2_common/boot_stage2/asminclude",
)

cc_library(
    name = "boot_stage2_h",
    hdrs = glob(["src/rp2_common/boot_stage2/include/boot_stage2/*.h"]),
    strip_include_prefix = "src/rp2_common/boot_stage2/include",
)

cc_library(
    name = "pico_base_h",
    hdrs = glob(["src/common/pico_base/include/pico/*.h"]) + ["src/common/pico_base/include/pico.h"],
    strip_include_prefix = "src/common/pico_base/include",
    deps = [":version_h"],
)

cc_library(
    name = "boards_h",
    hdrs = glob(["src/boards/include/boards/*.h"]),
    strip_include_prefix = "src/boards/include",
)

cc_library(
    name = "cmsis_h",
    hdrs = glob(["src/rp2_common/cmsis/include/cmsis/*.h"]),
    strip_include_prefix = "src/rp2_common/cmsis/include",
)

cc_library(
    name = "pico_platform_h",
    hdrs = glob([
        "src/rp2_common/pico_platform/include/pico/*.S",
        "src/rp2_common/pico_platform/include/pico/*.h",
    ]),
    strip_include_prefix = "src/rp2_common/pico_platform/include",
    deps = [
        ":pico_base_h",
        ":rp2040_hardware_regs",
    ],
)

cc_library(
    name = "rp2040_hardware_regs",
    hdrs = glob([
        "src/rp2040/hardware_regs/include/hardware/*.h",
        "src/rp2040/hardware_regs/include/hardware/regs/*.h",
    ]),
    strip_include_prefix = "src/rp2040/hardware_regs/include",
)

cc_library(
    name = "config_autogen_h",
    hdrs = [":gen_config_autogen_h"],
    include_prefix = "pico",
    deps = [
        ":boards_h",
        ":cmsis_h",
    ],
)

genrule(
    name = "gen_config_autogen_h",
    outs = [
        "config_autogen.h",
    ],
    cmd = """
        (echo '#include \"boards/pico.h\"';
         echo '#include \"cmsis/rename_exceptions.h\"') > $@
    """,
)

cc_library(
    name = "version_h",
    hdrs = [":gen_version_h"],
    include_prefix = "pico",
)

genrule(
    name = "gen_version_h",
    srcs = [
        "src/common/pico_base/include/pico/version.h.in",
    ],
    outs = [
        "version.h",
    ],
    cmd = """
        sed -e 's/$${PICO_SDK_VERSION_MAJOR}/1/' \
            -e 's/$${PICO_SDK_VERSION_MINOR}/3/' \
            -e 's/$${PICO_SDK_VERSION_REVISION}/0/' \
            -e 's/$${PICO_SDK_VERSION_STRING}/1.3.0/' < $< > $@
    """,
)
