#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/check_and_fix/check_buildifier.sh [--check|--fix]
# Check or format Bazel/Starlark files and report Buildifier lint warnings.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/internal/format_common.sh"

check_buildifier() {
    source_paths ':(glob)**/BUILD' ':(glob)**/BUILD.bazel' '*.bzl' '*.BUILD' ':(glob)**/MODULE.bazel' |
        xargs -0 -r buildifier -lint=warn "-mode=${1#--}"
}

mode=$(parse_format_mode "$@")
require_tool buildifier
enter_repository
check_buildifier "$mode"
