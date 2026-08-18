# Feature: Che Packages Definitions Update

<!-- [>] 🤖🤖 -->

The builtin package database ships in the `che-packages` module, released to the
generic package registry independently of che. `che packages update` fetches the
latest published definitions into the cache dir (`$XDG_CACHE_HOME/che/packages`).
Cached definitions supersede the compiled-in builtin when no user packages file
exists.

## As an operator

Keeps a host's packages current. Installs che, does not build it.

### New definitions without a che upgrade (tested)

I want `che packages update` to resolve the latest published che-packages
version from `latest/version.txt`, download its tarball, verify sha256 against
`checksums.txt`, extract `packages.yml` and `scripts/` atomically into
`<cache>/packages/<version>/`, mark it current and prune older cached versions,
so that catalog and binary move independently.

### Repeated update invocations staying cheap (tested)

I want an invocation inside the cooldown window to report the current cached
state without touching the registry, `--force` to re-check immediately, and an
already-cached latest version to refresh the check stamp and report up to date,
so that running update often costs nothing.

### An update check that never breaks offline installs (tested)

I want `packages.updateCheck.enabled` (default false, env
`CHE_PACKAGES_UPDATE_CHECK`) to run the update flow at installer construction,
skipped while the last check is younger than `packages.updateCheck.cooldown`
(default 15m, env `CHE_PACKAGES_UPDATE_CHECK_COOLDOWN`), a failure warning and
installs proceeding on the current cache or builtin,
so that a dead registry never blocks an install.

## As a config author

Decides which definitions a host uses. Writes the packages file, not the fetch
logic.

### A predictable precedence between definition sources (tested)

I want `--packages-file` to supersede everything, a user file at
`$XDG_CONFIG_HOME/packages/packages.yml` to supersede the cache, the cached
current version to supersede the compiled-in builtin, and the builtin to serve
when neither exists,
so that overriding definitions is one file, in one known order.

<!-- [<] 🤖🤖 -->
