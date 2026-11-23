#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/check_and_fix/code_coverage.sh [Bazel options] [targets]
# Run Bazel coverage and write bazel-coverage/index.html with lcov's genhtml.
# With no arguments, use //... as the target pattern.
set -euo pipefail

render_report() {
    local output_tree
    output_tree=$(bazel info output_path)
    genhtml "$output_tree/_coverage/_coverage_report.dat" --output-directory bazel-coverage
    test -s bazel-coverage/index.html
    printf 'Coverage report: %s/bazel-coverage/index.html\n' "$PWD"
}

main() {
    if ! command -v genhtml >/dev/null; then
        echo 'Install lcov to generate the HTML report.' >&2
        return 1
    fi

    local root
    root=$(git rev-parse --show-toplevel)
    cd "$root"
    if (($# == 0)); then
        set -- //...
    fi

    bazel coverage "$@"
    render_report
}

main "$@"
