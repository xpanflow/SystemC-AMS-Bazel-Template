load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_cc//cc:cc_library.bzl", "cc_library")
load("@rules_cc//cc:cc_test.bzl", "cc_test")

cc_library(
    name = "basic_adc",
    srcs = ["basic_adc.cpp"],
    hdrs = ["basic_adc.h"],
    visibility = ["//visibility:public"],
    deps = ["@systemc_ams"],
)

cc_library(
    name = "basic_adc_simulation",
    hdrs = ["basic_adc_simulation.h"],
    deps = [
        ":basic_adc",
        "@systemc",
        "@systemc_ams",
    ],
)

cc_binary(
    name = "basic_adc_demo",
    srcs = ["basic_adc_demo.cpp"],
    deps = [":basic_adc_simulation"],
)

cc_test(
    name = "basic_adc_test",
    size = "small",
    srcs = ["basic_adc_test.cpp"],
    deps = [
        ":basic_adc_simulation",
        "@googletest//:gtest",
    ],
)
