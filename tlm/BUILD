load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_cc//cc:cc_test.bzl", "cc_test")

cc_library(
    name = "target_memory",
    srcs = ["target_memory.cpp"],
    hdrs = ["target_memory.h"],
    deps = ["@systemc"],
)

cc_test(
    name = "blocking_memory",
    size = "small",
    srcs = ["blocking_memory.cpp"],
    deps = [
        ":target_memory",
        "@systemc",
    ],
)
