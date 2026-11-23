#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/check_and_fix/check_and_fix.sh [--check|--fix]
# Run all formatters. The default checks without writing; --fix applies edits.
set -euo pipefail

script_dir=$(dirname "${BASH_SOURCE[0]}")
source "$script_dir/internal/format_common.sh"

main() {
    local mode result=0
    mode=$(parse_format_mode "$@")

    # Check dependencies up front, then collect failures from every formatter.
    require_tool clang-format-18
    require_tool buildifier
    require_tool shfmt

    local check
    for check in check_clang_format.sh check_buildifier.sh check_shell_format.sh; do
        if ! "$script_dir/$check" "$mode"; then
            result=1
        fi
    done
    return "$result"
}

main "$@"
