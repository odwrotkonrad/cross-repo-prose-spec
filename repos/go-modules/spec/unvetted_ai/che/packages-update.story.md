# Feature: Che Packages Definitions Update

<!-- [>] 🤖🤖 -->

The builtin package database ships in the `che-packages` module, released to the
generic package registry on its own cadence. `che packages update` fetches the
latest published definitions into `$XDG_CACHE_HOME/che/packages`. Cached
definitions beat the compiled-in builtin when no user packages file exists.

Source and version are [configuration](packages-source.story.md). This spec
covers the fetch.

## As an operator

Keeps a host's packages current. Installs che, does not build it.

### New definitions without a che upgrade (tested)

I want `che packages update` to resolve the latest che-packages version from
`latest/version.txt`, download its tarball, verify sha256 against
`checksums.txt`, extract `packages.yml` and `scripts/` atomically into
`<cache>/packages/<version>/`, mark it current and prune older versions,
so that catalog and binary move independently.

### Repeated update invocations staying cheap (tested)

I want a run inside the cooldown to report the cached state without touching
the registry, `--force` to re-check immediately, and an already-cached latest
version to refresh the check stamp and report up to date,
so that running update often costs nothing.

### An update check that never breaks offline installs (tested)

I want `packages.autoUpdate.enabled` (default true, env
`CHE_PACKAGES_AUTO_UPDATE`) to run the update flow once per che execution,
skipped while the last check is younger than
`packages.autoUpdate.if.refIsLatest.cooldown` (default 15m, env
`CHE_PACKAGES_AUTO_UPDATE_COOLDOWN`), a failure warning and installs proceeding
on cache or builtin,
so that a dead registry never blocks an install.

## As a config author

Decides which definitions a host uses. Writes the packages file, not the fetch
logic.

### A predictable precedence between definition sources (tested)

I want `--packages-file` to beat everything, a user file at
`$XDG_CONFIG_HOME/packages/packages.yml` to beat the cache, the cached current
version to beat the builtin, and the builtin to serve when nothing else exists,
so that overriding definitions is one file, in one known order.

<!-- [<] 🤖🤖 -->
