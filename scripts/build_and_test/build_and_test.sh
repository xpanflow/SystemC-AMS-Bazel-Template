#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/build_and_test/build_and_test.sh [all|build|test] [Bazel options] [targets]
# Build debug and release, run tests, or run just one stage.
# With no Bazel arguments after the stage, use //... as the target pattern.
set -euo pipefail

build_targets() {
    bazel build --config=debug "$@"
    bazel build --config=release "$@"
}

test_targets() {
    bazel test "$@"
}

main() {
    local stage=${1:-all}
    if (($# > 0)); then
        shift
    fi
    if (($# == 0)); then
        set -- //...
    fi

    case "$stage" in
    all)
        build_targets "$@"
        test_targets "$@"
        ;;
    build) build_targets "$@" ;;
    test) test_targets "$@" ;;
    *)
        printf 'Usage: %s [all|build|test] [Bazel options] [targets]\n' "$0" >&2
        return 2
        ;;
    esac
}

main "$@"
