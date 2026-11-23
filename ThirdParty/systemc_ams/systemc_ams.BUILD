load("@rules_cc//cc:cc_import.bzl", "cc_import")
load("@rules_cc//cc:cc_library.bzl", "cc_library")

cc_import(
    name = "systemc_ams_static",
    static_library = "lib/libsystemc-ams.a",
)

cc_library(
    name = "systemc_ams",
    hdrs = glob(["include/**/*"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [
        ":systemc_ams_static",
        "@systemc",
    ],
)
