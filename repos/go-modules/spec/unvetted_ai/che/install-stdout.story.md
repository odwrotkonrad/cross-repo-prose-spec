# Feature: Install Stdout Silencing

<!-- [>] 🤖🤖 -->

At `CHE_LOG_LEVEL=info` (the default) installation-method stdout is noise:
apt/brew/npm progress drowns che's own lines. Silenced by default, controlled
by `--silence-install-stdout` on `che packages install`. Error output always
shows, debug shows everything.

## As an operator

Watches an install run and acts on what it prints. Does not read the installer
drivers.

### Che's own lines readable at the default level (tested)

I want installation-method stdout suppressed at `CHE_LOG_LEVEL=info` while
che's install, installed, skip and warn lines still print,
so that the run reads as che's log, not apt's.

### A failing method's output always visible (tested)

I want a non-0 installation method to print its captured output with the error
at any log level and any `--silence-install-stdout` value,
so that a failure is attributable without a rerun at debug.

### A failing install script naming its reason (implemented)

I want a script installer's stderr printed with the failure,
so that the cause is in the first run's output.

### A script failure's error line carrying the reason (todo)

I want the `<pkg>: install script: exit status <n>` error to carry the script's
stderr, not the bare exit status,
so that the reason survives where only the error line is read.

### Full method output on demand (tested)

I want `CHE_LOG_LEVEL=debug` (or `trace`) to stream the method's stdout live,
`--silence-install-stdout=false` to stream it even at info,
`--silence-install-stdout` to silence it even at debug,
so that verbosity is mine in either direction.

## As a CI maintainer

Owns the e2e suites and their assertions. Does not tune log levels per job.

### E2E suites keeping the plain info behavior (tested)

I want `make e2e-packages` and `make e2e-install-methods` to run che with
default silencing, no flag, no special-casing, asserting against che's own log
lines,
so that the tests prove what operators actually get.

<!-- [<] 🤖🤖 -->
