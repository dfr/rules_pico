def pico_sdk_library(*, name, srcdir = None, incdir = None, deps = []):
    if not incdir:
        incdir = srcdir + "/include"
    native.cc_library(
        name = name,
        srcs = native.glob([
            srcdir + "/*.c",
            srcdir + "/*.S",
        ], allow_empty = True),
        hdrs = native.glob([
            incdir + "/*/*.h",
            incdir + "/*/*.S",
        ]),
        strip_include_prefix = incdir,
    )
