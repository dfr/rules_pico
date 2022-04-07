def _get_gcc_path(rctx):
    res = rctx.execute([
        rctx.which("python3"),
        rctx.path(rctx.attr._detect),
    ])
    if res.return_code:
        fail("Failed to detect arm-none-eabi toolchain path: \n%s\n%s" % (res.stdout, res.stderr))
    return res.stdout.strip()

def _get_gcc_version(rctx, gccpath):
    res = rctx.execute([gccpath + "/bin/arm-none-eabi-gcc", "-v"])
    if res.return_code == 0:
        for line in res.stderr.split("\n"):
            if line.startswith("gcc version "):
                return line.split(" ")[2]
    fail("Failed to detect arm-none-eabi toolchain version: \n%s\n%s" % (res.stdout, res.stderr))

def _gcc_arm_embedded_toolchain_impl(rctx):
    gccpath = _get_gcc_path(rctx)
    gccver = _get_gcc_version(rctx, gccpath)
    rctx.file("BUILD", content = "")
    rctx.file("WORKSPACE", content = "")
    rctx.template(
        "cc_toolchain_config.bzl",
        rctx.attr._toolchain_config_template,
        {
            "{gccpath}": gccpath,
            "{gccver}": gccver,
        },
    )

gcc_arm_embedded_toolchain = repository_rule(
    implementation = _gcc_arm_embedded_toolchain_impl,
    local = True,
    attrs = {
        "_toolchain_config_template": attr.label(
            default = "@rules_pico//toolchain/private:cc_toolchain_config.bzl.tpl",
            allow_single_file = True,
        ),
        "_detect": attr.label(
            default = "@rules_pico//toolchain/private:detect.py",
            allow_single_file = True,
        ),
    },
)
