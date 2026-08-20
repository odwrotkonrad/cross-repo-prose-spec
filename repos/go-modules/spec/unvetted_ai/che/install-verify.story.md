# Feature: Install Verify

<!-- [>] 🤖🤖 -->

The `verify:` key in packages.yml declares how an install is proven. It sits on a
package entry (every method) or on an installer item (overriding the entry for
its method). Values:

- `versionCmd` (default when absent, scalar shorthand or `versionCmd: true`):
  run the entry's command with `--version` (fallback `version`), exit 0 and
  non-empty output required
- `pkgMgrVersionCheck` (scalar shorthand or `pkgMgrVersionCheck: true`): ask the
  installing manager for the installed version (apt: `dpkg-query -W`, brew:
  `brew list --versions`, brew/cask: `brew list --cask --versions`, npm:
  `npm ls --global`),
  exit 0 and non-empty output required
- `cmd: <command>`: run the command, exit 0 alone means verified
- object form combines: each strategy is its own key, several keys run all of
  them. `checkInPath: false` (default true) also disables the PATH presence
  probe

## As a catalog author

Declares how each package proves itself installed. Writes yaml, not verify
drivers.

### A working default that needs no declaration (tested)

I want an entry without a verify key to run the installed command with
`--version` (fallback `version`), exit 0 and non-empty output proving the
install,
so that the common package declares nothing.

### One strategy declared once for every method (tested)

I want an entry-level `verify:` to verify each of its methods' installs,
so that a package states its proof once.

### One method overriding the entry's proof (tested)

I want an item-level `verify:` to apply to its method while the entry's applies
to the rest,
so that an odd manager does not force the whole entry off the default.

### Several proofs combined, all required (tested)

I want a `verify:` object with several strategy keys to run each and require
each to pass,
so that a weak single check is not the only proof available.

### A binary-less package proven by its manager (implemented)

I want `verify: pkgMgrVersionCheck` to prove an apt item via
`dpkg-query -W -f '${Version}\n' <packageName>`, using the manager-side
packageName when it differs from the entry key, and to resolve per manager for
brew, brew/cask and npm,
so that a package shipping no binary is still verifiable.

### A command-less package opting out of the PATH probe (tested)

I want `checkInPath: false` to stop `che packages check` and the post-install
check probing for a command on PATH and firing a "missing" warning, the entry's
verify strategy still proving the install,
so that a package that is not a binary stops reporting as missing.

### An arbitrary command as proof (tested)

I want `verify: {cmd: <command>}` to run after the install, exit 0 verifying and
non-0 failing with no output requirement,
so that a package with its own health check uses it.

### A bad verify declaration caught at load (tested)

I want a `verify:` value that is neither a known strategy nor `{cmd: ...}` to
fail loading, naming the allowed values,
so that a typo never ships as an unverified install.

### An unsupported manager query failing clearly (tested)

I want `verify: pkgMgrVersionCheck` against a method with no version query
(e.g. go) to fail naming the unsupported method,
so that the declaration cannot silently prove nothing.

<!-- [<] 🤖🤖 -->
