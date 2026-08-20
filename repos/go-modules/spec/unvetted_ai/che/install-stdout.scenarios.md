# Feature: Install Stdout Silencing

<!-- [>] 🤖🤖 -->

Scenario: at info level the installation method's normal output is silenced (tested)
  Given `CHE_LOG_LEVEL=info` (the default)
  When `che packages install` runs an installation method (apt, brew, npm, ...)
  Then the method's stdout is not printed
  And che's own log lines (install, installed, skip, warn) still print

Scenario: a failing installation method's output is always visible (tested)
  Given any log level and any `--silence-install-stdout` value
  When an installation method exits non-0
  Then its captured output prints with the error
  And the failure is attributable without a rerun at debug

Scenario: a failing install script names its reason, not just an exit status (implemented)
  Given a script installer whose script writes its reason to stderr and exits non-0
  When the install runs at any log level, silenced or not
  Then the script's stderr prints with the failure

Scenario: a script failure's error line carries the reason (todo)
  Given a script installer whose script writes its reason to stderr and exits non-0
  When the install runs at any log level, silenced or not
  Then the error line says more than `<pkg>: install script: exit status <n>`

Scenario: --silence-install-stdout on the install command overrides the default (tested)
  When I invoke `che packages install --silence-install-stdout=false`
  Then the method's stdout streams even at info
  And `--silence-install-stdout` (or `=true`) silences it even at debug

Scenario: at debug level the installation method's output is visible (tested)
  Given `CHE_LOG_LEVEL=debug` (or `trace`)
  When `che packages install` runs an installation method
  Then the method's stdout streams as it runs

Scenario: e2e packages and install-methods tests keep the plain info behavior (tested)
  When `make e2e-packages` or `make e2e-install-methods` runs (CHE_LOG_LEVEL=info)
  Then che runs with default silencing, no flag, no special-casing
  And the tests assert against che's own log lines, not the methods' stdout

<!-- [<] 🤖🤖 -->
