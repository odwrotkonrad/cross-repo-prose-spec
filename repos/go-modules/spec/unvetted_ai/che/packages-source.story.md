# Feature: The Catalog Source Is Configuration

<!-- [>] 🤖🤖 -->

Before this: the definitions source was a compiled-in constant, the version
whatever `latest/version.txt` said. Neither settable from a spec file, user
config or flag. The constant's comment admitted it named a repo the catalog had
already left.

Three consequences. A host could not point at a fork or private mirror. A run
could not pin a catalog version, so two runs of one spec on one host could
install from different catalogs. CI, which needs exactly that pin, had to
bypass the option system.

The replacement is one vocabulary. `packages.source` says where and which:
`url`, `ref`. `packages.autoUpdate` says whether to move: `enabled`, plus the
conditions its sub-behaviours apply under. Naming the conditions keeps them
legible: a cooldown only means something while the ref floats, and a dry run is
the one context where fetching at all is in question.

```yaml
packages:
  source:
    url:
    ref:
  autoUpdate:
    enabled: true
    if:
      refIsLatest:
        cooldown: 15m
      dryRunIsTrue:
        enabled: true
```

Companion specs: [definitions update](packages-update.story.md),
[the vendored catalog](vendored-catalog.story.md),
[catalog pin propagation](../../../../cross-repo/automation/spec/unvetted_ai/sync/catalog-pin-propagation.story.md).

## As a config author

Declares where a host's definitions come from. Writes the spec, not the fetch
logic.

### Naming the catalog source without editing che (tested)

I want `packages.source.url` to name where definitions are read from, cascading
spec over user config like every other packages option,
so that a fork, mirror or private catalog needs no fork of che.

### A profile aiming at its own catalog (todo)

I want `packages.source` and `packages.autoUpdate` in profile options to beat
spec and user config,
so that one profile can read a different catalog than its host's default.

### One key covering both ways a catalog is published (tested)

I want a registry base URL and a git URL both accepted under that key, che
telling them apart itself,
so that I never declare the publishing mechanism.

### The default source naming the catalog's real home (tested)

I want an unset `packages.source.url` to resolve to the `konradodwrot/che-packages`
registry, the catalog the embedded copy was built from,
so that default and builtin never disagree about which catalog this is.

### Holding a host to an exact catalog version (tested)

I want `packages.source.ref` to name a published version, che fetching exactly
that,
so that a spec pinning its catalog installs the same definitions every run.

### A git-published catalog held to a branch, tag or commit (todo)

I want `packages.source.ref` against a git repository to name a branch, tag or
commit, che cloning exactly that,
so that a git catalog pins as precisely as a published one.

### Reading the conditions off the config (tested)

I want the keys under `autoUpdate.if` to say when their contents apply
(`refIsLatest`, `dryRunIsTrue`), not merely that a condition exists,
so that a cooldown under a floating ref is obviously the only cooldown there is.

## As an operator

Runs che on a real host. Installs it, does not build it.

### The newest catalog without asking for it (implemented)

I want `packages.autoUpdate.enabled` to default to true, an unpinned run
resolving the newest published catalog before installing,
so that a host stays current without me remembering to update it.

### One update check per che run, whatever the spec holds (tested)

I want one check per che execution, not one per profile,
so that a ten-profile run makes one round-trip.

### A pinned run never waiting on a cooldown (tested)

I want the cooldown to apply only while the ref floats, a pinned ref fetching
its version with no short-circuit,
so that asking for a known version always gets it.

### A dry run that works with the network gone (tested)

I want `autoUpdate.if.dryRunIsTrue.enabled` (default true) to decide whether a
dry run checks for updates at all,
so that planning offline is a config choice, not a failure.

### A failed fetch never being fatal (implemented)

I want a failed check to warn and fall through to the cached, then embedded,
catalog in every mode, dry run included,
so that a dead registry costs a warning, never a run.

<!-- [<] 🤖🤖 -->
