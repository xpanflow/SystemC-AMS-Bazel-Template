#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Shared helpers for the format scripts. Source this file from a checker.

parse_format_mode() {
    if (($# <= 1)); then
        case "${1:---check}" in
        --check | 1)
            printf '%s\n' --check
            return
            ;;
        --fix | 0)
            printf '%s\n' --fix
            return
            ;;
        esac
    fi
    printf 'Usage: %s [--check|--fix]\n' "$0" >&2
    return 2
}

require_tool() {
    if ! command -v "$1" >/dev/null; then
        printf 'Missing required formatter: %s\n' "$1" >&2
        return 1
    fi
}

enter_repository() {
    local root
    root=$(git rev-parse --show-toplevel)
    cd "$root"
}

# List tracked and new source files, skipping deleted paths, symlinks and ignored outputs.
source_paths() {
    git ls-files --cached --others --exclude-standard --deduplicate -z -- "$@" |
        while IFS= read -r -d '' path; do
            if [[ -f "$path" && ! -L "$path" ]]; then
                printf './%s\0' "$path"
            fi
        done
}
