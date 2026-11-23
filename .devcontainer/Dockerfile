# Copyright (c) 2022-2024 Xiao Pan

FROM ubuntu:24.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential ca-certificates clang-format-18 curl git lcov shfmt unzip zip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --retry 3 -o /usr/local/bin/bazel \
        https://github.com/bazelbuild/bazelisk/releases/download/v1.30.0/bazelisk-linux-amd64 \
    && echo 'a248ae2b2b62b5baebb748f6fba7203bff1a27e5d01b55399a8406744cb539e8  /usr/local/bin/bazel' | sha256sum -c - \
    && curl -fsSL --retry 3 -o /usr/local/bin/buildifier \
        https://github.com/bazel-contrib/buildtools/releases/download/v10.2.0/buildifier-linux-amd64 \
    && echo '470844069d710d0b7740e55007071c63e4d00be89a833dce5d1a91790e84dc28  /usr/local/bin/buildifier' | sha256sum -c - \
    && chmod 0755 /usr/local/bin/bazel /usr/local/bin/buildifier
