# Feature: Install Verify

<!-- [>] 🤖🤖 -->

Scenario: an installed package verifies by running its command by default (tested)
  Given a package entry without a verify key
  When its install e2e runs
  Then the installed command runs with `--version` (fallback `version`)
  And exit 0 with non-empty output proves the install

Scenario: multiple verify keys combine, every one must prove the install (tested)
  Given a `verify:` object with several strategy keys (e.g. `pkgMgrVersionCheck: true` and `cmd: <command>`)
  When the install e2e runs
  Then each declared verification runs and each must pass

Scenario: a package declares one verify strategy for all its methods (tested)
  Given an entry with `verify:` at entry level
  When the install e2e runs any of its methods
  Then that strategy verifies each method's install

Scenario: an installer item overrides the entry's verify for its method (tested)
  Given an entry-level `verify:` and an item-level `verify:` on one method
  When the install e2e runs
  Then the item's verify applies to its method
  And the entry's verify applies to the remaining methods

Scenario: a binary-less apt package verifies via the manager's version query (tested)
  Given an apt item with `verify: pkgMgrVersionCheck` (e.g. apt-transport-https)
  When its install e2e runs
  Then `dpkg-query -W -f '${Version}\n' <packageName>` proves the install
  And the manager-side packageName is used when it differs from the entry key

Scenario: pkgMgrVersionCheck resolves per manager (implemented)
  Given an entry with `verify: pkgMgrVersionCheck` and brew, brew/cask or npm methods
  When the install e2e runs
  Then each method verifies via its own manager's version query

Scenario: a command-less package opts out of the PATH probe (verify.checkInPath) (tested)
  Given a `verify:` object with `checkInPath: false` (default true, combinable with the strategy keys and `cmd`)
  When presence checks run (`che packages check`, the post-install check)
  Then the package is not probed for a command on PATH and no "missing" warning fires
  And the install is still proven by the entry's verify strategy (e.g. apt-transport-https via `pkgMgrVersionCheck`, nvm via its sourcing `cmd`)

Scenario: a custom verify cmd succeeds on exit 0 alone (tested)
  Given a `verify: {cmd: <command>}`
  When the install e2e runs
  Then the command runs after the install
  And exit 0 verifies, non-0 fails, output is not required

Scenario: an unknown verify value fails at parse time (tested)
  Given a `verify:` value that is neither a known strategy nor `{cmd: ...}`
  When the packages file loads
  Then loading fails naming the allowed values

Scenario: pkgMgrVersionCheck on a manager without a version query fails clearly (tested)
  Given `verify: pkgMgrVersionCheck` resolving against a method without a version query (e.g. go)
  When the install e2e runs
  Then the test fails naming the unsupported method

<!-- [<] 🤖🤖 -->
