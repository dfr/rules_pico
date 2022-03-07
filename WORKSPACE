workspace(name = "rules_pico")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//pico:repositories.bzl", "rules_pico_dependencies", "rules_pico_toolchains")

http_archive(
    name = "rules_foreign_cc",
    # TODO: Get the latest sha256 value from a bazel debug message or the latest 
    #       release on the releases page: https://github.com/bazelbuild/rules_foreign_cc/releases
    #
    # sha256 = "...",
    strip_prefix = "rules_foreign_cc-0.7.0",
    url = "https://github.com/bazelbuild/rules_foreign_cc/archive/0.7.0.tar.gz",
)

local_repository(
    name = "rules_foreign_cc_",
    path = "/home/dfr/src/rules_foreign_cc",
)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies(
    register_preinstalled_tools = True,
    register_built_tools = False,
)

rules_pico_dependencies()
rules_pico_toolchains();

#new_local_repository(
#    name = "pico-sdk",
#    path = "/projects/rpi/pico/pico-sdk",
#    build_file = "pico-sdk.BUILD",
#)

#new_local_repository(
#    name = "pico-examples",
#    path = "/projects/rpi/pico/pico-examples",
#    build_file = "pico-examples.BUILD",
#)

#register_toolchains(
#    "//toolchain:gcc-arm-embedded",
#)
