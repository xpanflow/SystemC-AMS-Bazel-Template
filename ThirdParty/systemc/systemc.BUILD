load("@rules_cc//cc:cc_import.bzl", "cc_import")
load("@rules_cc//cc:cc_library.bzl", "cc_library")

cc_import(
    name = "systemc_shared",
    shared_library = "lib/libsystemc.so.2.3",
)

cc_library(
    name = "systemc",
    hdrs = glob(["include/**/*"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    deps = [":systemc_shared"],
)
