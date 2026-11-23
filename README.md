# SystemC, TLM, and AMS Bazel template

A C++14 starter with a SystemC-AMS ADC and a SystemC TLM-2.0 memory example. Bazel fetches the pinned Linux x86-64 libraries. [Dependency configuration](MODULE.bazel)

## Quick start

Open the repository in the Ubuntu 24.04 devcontainer or use an x86-64 Linux host with GCC and Bazelisk installed as `bazel`. Bazelisk reads `.bazelversion`. The first run downloads tools and dependencies. [Devcontainer](.devcontainer/Dockerfile)

```bash
./scripts/build_and_test/build_and_test.sh
bazel run //sca/basic_adc:basic_adc_demo
bazel run //tlm:blocking_memory
```

- The ADC samples 0 V, 0.5 V, and 1 V and prints codes `0`, `2047`, and `4095` with the default 1 V reference and 12-bit resolution. The TDF stimulus sets the sample interval. [ADC example](sca/basic_adc/)
- The TLM initiator uses `b_transport` to write `0x2a` at address `0x10`, reads the byte back, and checks both responses. [TLM example](tlm/)

## Local checks and CI

| Command | Result |
| --- | --- |
| `./scripts/check_and_fix/check_and_fix.sh` | Check C++, Bazel, and shell formatting. Pass `--fix` to apply edits. |
| `./scripts/test_workflows.sh` | Verify developer script behavior. |
| `./scripts/build_and_test/build_and_test.sh build` | Build the debug and release profiles. |
| `bazel test //...` | Run the ADC simulation checks and the TLM round trip. |
| `./scripts/check_and_fix/code_coverage.sh` | Generate `bazel-coverage/index.html`. |

GitHub Actions runs Check → Build → Test → Coverage in the devcontainer and uploads the HTML report as `coverage-html`. [CI workflow](.github/workflows/main.yml)

## License

[MIT](LICENSE)
