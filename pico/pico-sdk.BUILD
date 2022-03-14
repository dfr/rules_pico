# -*- bazel-build -*-

load("@rules_pico//pico/private:defs.bzl", "pico_sdk_library", "pico_simple_hardware_target")

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

# boot_stage2

genrule(
    name = "bs2_default_padded_checksummed",
    srcs = ["bs2_default.bin"],
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
    srcs = ["bs2_default.elf"],
    outs = ["bs2_default.bin"],
    cmd = "$(OBJCOPY) -O binary $< $@",
    toolchains = ["@bazel_tools//tools/cpp:current_cc_toolchain"],
)

cc_binary(
    name = "bs2_default.elf",
    srcs = [
        "src/rp2_common/boot_stage2/compile_time_choice.S",
    ],
    copts = ["-Isrc/rp2_common/boot_stage2"],
    linkopts = [
        "--specs=nosys.specs",
        "-nostartfiles",
        "-Wl,--script=$(rootpath src/rp2_common/boot_stage2/boot_stage2.ld)",
    ],
    deps = [
        "src/rp2_common/boot_stage2/boot_stage2.ld",
        ":boot_stage2_asm",
        ":boot_stage2_headers",
        ":pico_base",
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "boot_stage2_asm",
    incdir = "src/rp2_common/boot_stage2",
    deps = [":boot_stage2_asminclude"],
)

pico_sdk_library(
    name = "boot_stage2_asminclude",
    incdir = "src/rp2_common/boot_stage2/asminclude",
)

pico_sdk_library(
    name = "boot_stage2_headers",
    incdir = "src/rp2_common/boot_stage2/include",
)

# boot_uf2, elf2uf2

pico_sdk_library(
    name = "boot_uf2",
    srcdir = "src/common/boot_uf2",
    incdir = "src/common/boot_uf2/include",
)

cc_binary(
    name = "elf2uf2",
    srcs = [
        "tools/elf2uf2/elf.h",
        "tools/elf2uf2/main.cpp",
    ],
    target_compatible_with = select({
        "@platforms//os:freebsd": [],
        "@platforms//os:osx": [],
        "@platforms//os:linux": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }),
    visibility = ["//visibility:public"],
    deps = [
        ":boot_uf2",
    ],
)

# boards, cmsis

pico_sdk_library(
    name = "boards",
    incdir = "src/boards/include",
)

pico_sdk_library(
    name = "cmsis",
    incdir = "src/rp2_common/cmsis/include",
)

# pico_base

[
    config_setting(
        name = "board_" + n,
        flag_values = {"@rules_pico//pico/config:board": n},
    )
    for n in [
        "pico",
        "vgaboard",
    ]
]

cc_library(
    name = "pico_base",
    hdrs = [
        "src/common/pico_base/include/pico.h",
        "src/common/pico_base/include/pico/assert.h",
        "src/common/pico_base/include/pico/config.h",
        "src/common/pico_base/include/pico/config_autogen.h",
        "src/common/pico_base/include/pico/error.h",
        "src/common/pico_base/include/pico/types.h",
        "src/common/pico_base/include/pico/version.h",
    ],
    defines = select({
        ":board_pico": ["PICO_BOARD=\\\"pico\\\""],
        ":board_vgaboard": ["PICO_BOARD=\\\"vgaboard\\\""],
    }) + ["LIB_PICO_BASE"],
    strip_include_prefix = "src/common/pico_base/include",
    deps = [
        ":boards",
        ":cmsis",
    ],
)

genrule(
    name = "gen_config_autogen",
    outs = [
        "src/common/pico_base/include/pico/config_autogen.h",
    ],
    cmd = """
        (echo '#include \"boards/pico.h\"';
         echo '#include \"cmsis/rename_exceptions.h\"') > $@
    """,
)

genrule(
    name = "gen_version",
    srcs = [
        "src/common/pico_base/include/pico/version.h.in",
    ],
    outs = [
        "src/common/pico_base/include/pico/version.h",
    ],
    cmd = """
        sed -e 's/$${PICO_SDK_VERSION_MAJOR}/1/' \
            -e 's/$${PICO_SDK_VERSION_MINOR}/3/' \
            -e 's/$${PICO_SDK_VERSION_REVISION}/0/' \
            -e 's/$${PICO_SDK_VERSION_STRING}/1.3.0/' < $< > $@
    """,
)

# pico_*

pico_sdk_library(
    name = "pico_binary_info",
    srcdir = "src/common/pico_binary_info",
    defines = ["PICO_NO_BINARY_INFO=0"],
    incdir = "src/common/pico_binary_info/include",
)

pico_sdk_library(
    name = "pico_bootrom",
    srcdir = "src/rp2_common/pico_bootrom",
    incdir = "src/rp2_common/pico_bootrom/include",
    deps = [
        ":pico_platform",
    ],
)

alias(
    name = "pico_double",
    actual = "@rules_pico//pico/config:double_impl",
)

cc_library(
    name = "pico_double_pico",
    srcs = [
        "src/rp2_common/pico_double/double_aeabi.S",
        "src/rp2_common/pico_double/double_init_rom.c",
        "src/rp2_common/pico_double/double_math.c",
        "src/rp2_common/pico_double/double_v1_rom_shim.S",
    ],
    defines = ["LIB_PICO_DOUBLE_PICO"],
    deps = [
        ":hardware_divider",
        ":pico_double_headers",
    ],
    alwayslink = True,
)

cc_library(
    name = "pico_double_none",
    srcs = [
        "src/rp2_common/pico_double/double_none.S",
    ],
    defines = ["LIB_PICO_DOUBLE_NONE"],
    deps = [
        ":pico_double_headers",
    ],
    alwayslink = True,
)

cc_library(
    name = "pico_double_headers",
    hdrs = [
        "src/rp2_common/pico_double/include/pico/double.h",
    ],
    strip_include_prefix = "src/rp2_common/pico_double/include",
    deps = [
        ":pico_bootrom",
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "pico_divider",
    srcdir = "src/rp2_common/pico_divider",
    incdir = "src/rp2_common/pico_divider/include",
    deps = [
        ":hardware_divider",
        ":pico_bootrom",
        ":pico_platform",
    ],
    alwayslink = True,
)

alias(
    name = "pico_float",
    actual = "@rules_pico//pico/config:float_impl",
)

cc_library(
    name = "pico_float_pico",
    srcs = [
        "src/rp2_common/pico_float/float_aeabi.S",
        "src/rp2_common/pico_float/float_init_rom.c",
        "src/rp2_common/pico_float/float_math.c",
        "src/rp2_common/pico_float/float_v1_rom_shim.S",
    ],
    defines = ["LIB_PICO_FLOAT_PICO"],
    deps = [
        ":hardware_divider",
        ":pico_float_headers",
    ],
    alwayslink = True,
)

cc_library(
    name = "pico_float_none",
    srcs = [
        "src/rp2_common/pico_float/float_none.S",
    ],
    defines = ["LIB_PICO_FLOAT_NONE"],
    deps = [
        ":pico_float_headers",
    ],
    alwayslink = True,
)

cc_library(
    name = "pico_float_headers",
    hdrs = [
        "src/rp2_common/pico_float/include/pico/float.h",
    ],
    strip_include_prefix = "src/rp2_common/pico_float/include",
    deps = [
        ":pico_bootrom",
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "pico_int64_ops",
    srcdir = "src/rp2_common/pico_int64_ops",
    incdir = "src/rp2_common/pico_int64_ops/include",
    deps = [
        ":pico_bootrom",
        ":pico_platform",
    ],
    alwayslink = True,
)

pico_sdk_library(
    name = "pico_malloc",
    srcdir = "src/rp2_common/pico_malloc",
    incdir = "src/rp2_common/pico_malloc/include",
    deps = [
        ":pico_platform",
    ],
    alwayslink = True,
)

pico_sdk_library(
    name = "pico_mem_ops",
    srcdir = "src/rp2_common/pico_mem_ops",
    incdir = "src/rp2_common/pico_mem_ops/include",
    deps = [
        ":pico_bootrom",
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "pico_multicore",
    srcdir = "src/rp2_common/pico_multicore",
    incdir = "src/rp2_common/pico_multicore/include",
    deps = [
        ":hardware_irq",
        ":pico_bootrom",
        ":pico_platform",
        ":pico_sync",
    ],
)

pico_sdk_library(
    name = "pico_platform",
    srcdir = "src/rp2_common/pico_platform",
    deps = [
        ":hardware_base",
        ":hardware_regs",
        ":pico_platform_headers",
    ],
)

pico_sdk_library(
    name = "pico_platform_headers",
    incdir = "src/rp2_common/pico_platform/include",
    deps = [
        ":pico_base",
    ],
)

pico_sdk_library(
    name = "pico_printf_headers",
    incdir = "src/rp2_common/pico_printf/include",
    deps = [
        ":pico_bootrom",
        ":pico_platform",
    ],
)

cc_library(
    name = "pico_printf_pico",
    srcs = [
        "src/rp2_common/pico_printf/printf.c",
    ],
    defines = ["LIB_PICO_PRINTF_PICO"],
    deps = [
        ":pico_printf_headers",
    ],
    alwayslink = True,
)

alias(
    name = "pico_printf",
    actual = ":pico_printf_pico",
)

pico_sdk_library(
    name = "pico_runtime",
    srcdir = "src/rp2_common/pico_runtime",
    incdir = "src/rp2_common/pico_runtime/include",
    deps = [
        ":hardware_clocks",
        ":hardware_irq",
        ":hardware_uart",
        ":pico_binary_info",
        ":pico_bootrom",
        ":pico_divider",
        ":pico_double",
        ":pico_float",
        ":pico_int64_ops",
        ":pico_malloc",
        ":pico_mem_ops",
        ":pico_printf",
        ":pico_sync",
    ],
)

pico_sdk_library(
    name = "pico_standard_link",
    srcdir = "src/rp2_common/pico_standard_link",
    defines = ["PICO_ON_DEVICE"],
    deps = [
        ":boot_stage2_headers",
        ":pico_binary_info",
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "pico_stdlib",
    srcdir = "src/rp2_common/pico_stdlib",
    deps = [
        ":pico_binary_info",
        ":pico_platform",
        ":pico_runtime",
        ":pico_standard_link",
        ":pico_stdio",
        ":pico_stdlib_headers",
        ":pico_time",
    ],
)

pico_sdk_library(
    name = "pico_stdlib_headers",
    incdir = "src/common/pico_stdlib/include",
    deps = [
        ":hardware_divider",
        ":hardware_gpio",
        ":hardware_uart",
        ":pico_time",
        ":pico_util",
    ],
)

[config_setting(
    name = n,
    flag_values = {"@rules_pico//pico/config:" + n: "True"},
) for n in [
    "stdio_uart",
    "stdio_usb",
    "stdio_semihosting",
]]

pico_sdk_library(
    name = "pico_stdio",
    srcdir = "src/rp2_common/pico_stdio",
    incdir = "src/rp2_common/pico_stdio/include",
    deps = [
        ":hardware_irq",
        ":hardware_pll",
        ":hardware_regs",
        ":pico_base",
        ":pico_stdio_headers",
        ":pico_sync",
    ] + select({
        ":stdio_uart": [":pico_stdio_uart"],
        "//conditions:default": [],
    }) + select({
        ":stdio_usb": [":pico_stdio_usb"],
        "//conditions:default": [],
    }) + select({
        ":stdio_semihosting": [":pico_stdio_semihosting"],
        "//conditions:default": [],
    }),
)

pico_sdk_library(
    name = "pico_stdio_headers",
    incdir = "src/rp2_common/pico_stdio/include",
    deps = [
        ":pico_platform",
    ],
)

pico_sdk_library(
    name = "pico_stdio_uart",
    srcdir = "src/rp2_common/pico_stdio_uart",
    incdir = "src/rp2_common/pico_stdio_uart/include",
    deps = [
        ":hardware_gpio",
        ":hardware_uart",
        ":pico_binary_info",
        ":pico_stdio_headers",
    ],
)

pico_sdk_library(
    name = "pico_stdio_usb",
    srcdir = "src/rp2_common/pico_stdio_usb",
    incdir = "src/rp2_common/pico_stdio_usb/include",
    deps = [
        ":hardware_gpio",
        ":hardware_uart",
        ":pico_binary_info",
        ":pico_bootrom",
        ":pico_stdio_usb_headers",
        ":pico_unique_id",
        ":pico_usb_reset_interface",
        ":tinyusb_device_unmarked",
    ],
    alwayslink = True,  # XXX force stdio_usb_descriptors to link
)

pico_sdk_library(
    name = "pico_stdio_usb_headers",
    incdir = "src/rp2_common/pico_stdio_usb/include",
    deps = [
        ":pico_stdio_headers",
    ],
)

pico_sdk_library(
    name = "pico_stdio_semihosting",
    srcdir = "src/rp2_common/pico_stdio_semihosting",
    incdir = "src/rp2_common/pico_stdio_semihosting/include",
    deps = [
        ":pico_binary_info",
        ":pico_stdio_headers",
    ],
)

pico_sdk_library(
    name = "pico_sync",
    srcdir = "src/common/pico_sync",
    deps = [
        ":hardware_claim",
        ":hardware_regs",
        ":pico_base",
        ":pico_sync_headers",
        ":pico_time_headers",
    ],
)

pico_sdk_library(
    name = "pico_sync_headers",
    incdir = "src/common/pico_sync/include",
    deps = [
        ":hardware_sync_headers",
    ],
)

pico_sdk_library(
    name = "pico_time",
    srcdir = "src/common/pico_time",
    deps = [
        ":hardware_timer",
        ":pico_sync",
        ":pico_time_headers",
        ":pico_util",
    ],
)

pico_sdk_library(
    name = "pico_time_headers",
    incdir = "src/common/pico_time/include",
    deps = [
        ":hardware_timer_headers",
    ],
)

pico_sdk_library(
    name = "pico_unique_id",
    srcdir = "src/rp2_common/pico_unique_id",
    incdir = "src/rp2_common/pico_unique_id/include",
    deps = [
        ":hardware_flash",
    ],
)

pico_sdk_library(
    name = "pico_usb_reset_interface",
    incdir = "src/common/pico_usb_reset_interface/include",
)

pico_sdk_library(
    name = "pico_util",
    srcdir = "src/common/pico_util",
    incdir = "src/common/pico_util/include",
    deps = [
        ":hardware_regs",
        ":hardware_sync",
        ":pico_base",
        ":pico_sync",
    ],
)

# tinyusb

cc_library(
    name = "tinyusb_common",
    deps = [
        ":tinyusb_common_base",
    ],
)

cc_library(
    name = "tinyusb_common_base",
    srcs = [
        "lib/tinyusb/src/common/tusb_fifo.c",
        "lib/tinyusb/src/tusb.c",
    ],
    local_defines = [
        "CFG_TUSB_MCU=OPT_MCU_RP2040",
        "CFG_TUSB_OS=OPT_OS_PICO",
        "CFG_TUSB_DEBUG=0",
    ],
    deps = [
        ":hardware_irq",
        ":hardware_resets",
        ":hardware_structs",
        ":pico_stdio_usb_headers",  # XXX
        ":pico_sync",
        ":tinyusb_headers",
    ],
)

cc_library(
    name = "pico_fix_rp2040_usb_device_enumeration",
    srcs = [
        "lib/tinyusb/src/portable/raspberrypi/rp2040/dcd_rp2040.c",
    ],
    deps = [
        ":pico_stdio_usb_headers",  # XXX
        ":tinyusb_headers",
    ],
)

cc_library(
    name = "tinyusb_device_unmarked",
    deps = [
        ":pico_fix_rp2040_usb_device_enumeration",
        ":tinyusb_common",
        ":tinyusb_device_base",
    ],
)

cc_library(
    name = "tinyusb_device_base",
    srcs = [
        "lib/tinyusb/src/class/audio/audio_device.c",
        "lib/tinyusb/src/class/cdc/cdc_device.c",
        "lib/tinyusb/src/class/dfu/dfu_device.c",
        "lib/tinyusb/src/class/dfu/dfu_rt_device.c",
        "lib/tinyusb/src/class/hid/hid_device.c",
        "lib/tinyusb/src/class/midi/midi_device.c",
        "lib/tinyusb/src/class/msc/msc_device.c",
        "lib/tinyusb/src/class/net/ecm_rndis_device.c",
        "lib/tinyusb/src/class/net/ncm_device.c",
        "lib/tinyusb/src/class/usbtmc/usbtmc_device.c",
        "lib/tinyusb/src/class/vendor/vendor_device.c",
        "lib/tinyusb/src/class/video/video_device.c",
        "lib/tinyusb/src/device/usbd.c",
        "lib/tinyusb/src/device/usbd_control.c",
        "lib/tinyusb/src/portable/raspberrypi/rp2040/dcd_rp2040.c",
        "lib/tinyusb/src/portable/raspberrypi/rp2040/rp2040_usb.c",
    ],
    local_defines = [
        "CFG_TUSB_MCU=OPT_MCU_RP2040",
        "CFG_TUSB_OS=OPT_OS_PICO",
        "CFG_TUSB_DEBUG=0",
    ],
    deps = [
        ":pico_stdio_usb_headers",  # XXX
        ":pico_time",
        ":tinyusb_common_base",
    ],
)

cc_library(
    name = "tinyusb_headers",
    hdrs = glob([
        "lib/tinyusb/src/**/*.h",
    ]),
    strip_include_prefix = "lib/tinyusb/src",
)

# hardware_*

pico_simple_hardware_target(
    name = "hardware_adc",
    deps = [
        ":hardware_gpio",
        ":hardware_resets",
    ],
)

pico_sdk_library(
    name = "hardware_base",
    incdir = "src/rp2_common/hardware_base/include",
)

pico_simple_hardware_target(
    name = "hardware_claim",
    deps = [
        ":hardware_sync_headers",
    ],
)

pico_simple_hardware_target(
    name = "hardware_clocks",
    deps = [
        ":hardware_gpio",
        ":hardware_irq",
        ":hardware_pll",
        ":hardware_watchdog",
        ":hardware_xosc",
    ],
)

pico_simple_hardware_target(
    name = "hardware_divider",
)

pico_simple_hardware_target(
    name = "hardware_dma",
    deps = [
        ":hardware_claim",
    ],
)

pico_simple_hardware_target(
    name = "hardware_exception",
    deps = [
        ":pico_sync_headers",
        ":pico_time_headers",
    ],
)

pico_simple_hardware_target(
    name = "hardware_flash",
    deps = [
        ":pico_bootrom",
    ],
)

pico_simple_hardware_target(
    name = "hardware_gpio",
    deps = [
        ":hardware_irq",
        ":hardware_sync",
    ],
)

pico_simple_hardware_target(
    name = "hardware_i2c",
    deps = [
        ":hardware_clocks",
        ":hardware_resets",
        ":pico_time",
    ],
)

pico_simple_hardware_target(
    name = "hardware_interp",
    deps = [
        ":hardware_claim",
    ],
)

pico_simple_hardware_target(
    name = "hardware_irq",
    deps = [
        ":pico_sync_headers",
        ":pico_time_headers",
    ],
)

pico_simple_hardware_target(
    name = "hardware_pio",
    deps = [
        ":hardware_claim",
        ":hardware_gpio",
    ],
)

pico_simple_hardware_target(
    name = "hardware_pll",
    deps = [
        ":hardware_clocks_headers",
        ":hardware_resets",
    ],
)

pico_sdk_library(
    name = "hardware_regs",
    incdir = "src/rp2040/hardware_regs/include",
)

pico_simple_hardware_target(
    name = "hardware_resets",
)

pico_simple_hardware_target(
    name = "hardware_rtc",
    deps = [
        ":hardware_clocks",
        ":hardware_irq",
        ":hardware_resets",
    ],
)

pico_simple_hardware_target(
    name = "hardware_spi",
    deps = [
        ":hardware_clocks",
        ":hardware_resets",
        ":pico_time",
    ],
)

pico_sdk_library(
    name = "hardware_structs",
    incdir = "src/rp2040/hardware_structs/include",
)

pico_simple_hardware_target(
    name = "hardware_sync",
    deps = [
        ":hardware_claim",
    ],
)

pico_simple_hardware_target(
    name = "hardware_timer",
    deps = [
        ":hardware_claim",
        ":hardware_irq",
        ":hardware_sync",
    ],
)

pico_simple_hardware_target(
    name = "hardware_uart",
    deps = [
        ":hardware_clocks",
        ":hardware_resets",
        ":hardware_timer",
    ],
)

pico_simple_hardware_target(
    name = "hardware_vreg",
)

pico_simple_hardware_target(
    name = "hardware_watchdog",
)

pico_simple_hardware_target(
    name = "hardware_xosc",
    deps = [
        ":hardware_clocks_headers",
    ],
)
