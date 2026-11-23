#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/check_and_fix/check_clang_format.sh [--check|--fix]
# Check or format C and C++ files with clang-format-18 and .clang-format.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/internal/format_common.sh"

check_clang_format() {
    local -a flags=(--dry-run --Werror)
    if [[ "$1" == --fix ]]; then
        flags=(-i)
    fi

    source_paths '*.c' '*.C' '*.cc' '*.cpp' '*.cxx' '*.h' '*.H' '*.hh' '*.hpp' '*.hxx' '*.cl' |
        xargs -0 -r clang-format-18 "${flags[@]}"
}

mode=$(parse_format_mode "$@")
require_tool clang-format-18
enter_repository
check_clang_format "$mode"
