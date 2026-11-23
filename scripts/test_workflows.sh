#!/usr/bin/env bash
# Copyright (c) 2022-2024 Xiao Pan

# Usage: ./scripts/test_workflows.sh
# Verify workflow scripts in disposable Git repositories.
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
format_script="$script_dir/check_and_fix/check_and_fix.sh"
coverage_script="$script_dir/check_and_fix/code_coverage.sh"
build_script="$script_dir/build_and_test/build_and_test.sh"

test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT

run_case() (
    local name=$1
    local case_dir="$test_root/$name"
    local bin="$case_dir/bin" result
    mkdir -p "$bin"
    git init --quiet "$case_dir/repo"
    cd "$case_dir/repo"

    "$name"
    printf 'PASS %s\n' "$name"
)

run_script() {
    result=0
    "$@" >"$case_dir/stdout" 2>"$case_dir/stderr" || result=$?
}

fail() {
    printf 'FAIL %s\n%s\n' "$name" "$*" >&2
    cat "$case_dir/stdout" "$case_dir/stderr" >&2
    exit 1
}

expect_status() {
    [[ "$result" == "$1" ]] || fail "Expected exit $1, got $result."
}

malformed_shell_fails() {
    printf 'if true; then\n' >"broken script.sh"

    run_script "$format_script"
    ((result != 0)) || fail 'Malformed shell passed the format check.'
    grep -Fq 'broken script.sh' "$case_dir/stderr" || fail 'The error omitted the filename.'
}

format_check_is_read_only() {
    local script='new script.sh'
    printf '#!/bin/bash\necho    hello\n' >"$script"

    run_script "$format_script"
    ((result != 0)) || fail 'The format check accepted unformatted shell.'
    cmp -s "$script" <(printf '#!/bin/bash\necho    hello\n') || fail 'The check modified the source.'

    run_script "$format_script" --fix
    expect_status 0
    cmp -s "$script" <(printf '#!/bin/bash\necho hello\n') || fail 'Fix mode produced unexpected formatting.'

    run_script "$format_script"
    expect_status 0
}

missing_formatter_fails() {
    local tool
    for tool in bash dirname git buildifier clang-format-18; do
        ln -s "$(type -P "$tool")" "$bin/$tool"
    done

    run_script env PATH="$bin" "$format_script"
    ((result != 0)) || fail 'The format check passed without shfmt.'
    grep -Fq 'shfmt' "$case_dir/stderr" || fail 'The error omitted the missing tool.'
}

bazel_failures_propagate() {
    cat >"$bin/bazel" <<'STUB'
#!/bin/bash
case "$*" in
*--config=release* | coverage*) exit 23 ;;
esac
STUB
    chmod +x "$bin/bazel"

    run_script env PATH="$bin:$PATH" "$build_script"
    expect_status 23

    run_script env PATH="$bin:$PATH" "$coverage_script"
    expect_status 23
    if grep -Fq 'index.html' "$case_dir/stdout" || [[ -e bazel-coverage/index.html ]]; then
        fail 'Coverage reported an HTML result after Bazel failed.'
    fi
}

bazel_arguments_are_forwarded() {
    cat >"$bin/bazel" <<'STUB'
#!/bin/bash
printf '%s\n' "$*"
STUB
    chmod +x "$bin/bazel"

    run_script env PATH="$bin:$PATH" "$build_script" build --config=ci //sca/basic_adc:basic_adc_test
    expect_status 0
    cmp -s "$case_dir/stdout" <(printf '%s\n' \
        'build --config=debug --config=ci //sca/basic_adc:basic_adc_test' \
        'build --config=release --config=ci //sca/basic_adc:basic_adc_test') || fail 'Build forwarded unexpected arguments.'

    run_script env PATH="$bin:$PATH" "$build_script" test --config=ci //sca/basic_adc:basic_adc_test
    expect_status 0
    cmp -s "$case_dir/stdout" <(printf '%s\n' 'test --config=ci //sca/basic_adc:basic_adc_test') ||
        fail 'Test forwarded unexpected arguments.'
}

run_case malformed_shell_fails
run_case format_check_is_read_only
run_case missing_formatter_fails
run_case bazel_failures_propagate
run_case bazel_arguments_are_forwarded
