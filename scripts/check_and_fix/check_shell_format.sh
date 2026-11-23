#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/check_and_fix/check_shell_format.sh [--check|--fix]
# Check Bash syntax and formatting with shfmt, or apply its formatting with --fix.
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/internal/format_common.sh"

check_shell_format() {
    local flag=-d
    if [[ "$1" == --fix ]]; then
        flag=-w
    fi

    source_paths '*.sh' | xargs -0 -r shfmt -i 4 "$flag"
}

mode=$(parse_format_mode "$@")
require_tool shfmt
enter_repository
check_shell_format "$mode"
