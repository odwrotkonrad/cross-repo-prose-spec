# Feature: The Catalog Source Is Configuration

<!-- [>] 🤖🤖 -->

Where che reads package definitions from is a compiled-in constant, and which
version it reads is always whatever `latest/version.txt` says. Neither is
expressible in a spec file, a user config or a flag. The constant still carries
a comment admitting it names the repo the catalog has already left.

That leaves three things impossible. A host cannot be aimed at a fork or a
private mirror. A run cannot be held to an exact catalog version, so two runs of
one spec on one host can install from different catalogs. And CI, which needs
exactly the second, has to reach around the option system entirely.

The replacement is one vocabulary. `packages.source` says where and which:
`url` for the location, `ref` for the version. `packages.autoUpdate` says
whether to move: `enabled`, plus the conditions under which its sub-behaviours
apply. Naming the conditions is what makes them legible, because a cooldown only
means something while the ref floats, and a dry run is the one context where
fetching at all is a question.

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
[catalog pin propagation](../../../../control/spec/unvetted_ai/sync/catalog-pin-propagation.story.md).

## As a config author

Declares where a host's definitions come from. Writes the spec file, not the
fetch logic.

### Naming the catalog source without editing che (tested)

I want `packages.source.url` to accept the location definitions are read from,
cascading spec over user config like every other packages option,
so that a fork, a mirror or a private catalog needs no fork of che.

### A profile aiming at its own catalog (todo)

I want `packages.source` and `packages.autoUpdate` set in profile options to
beat the spec and user config values,
so that one profile can read a different catalog than its host's default.

### One key covering both ways a catalog is published (tested)

I want a registry base URL and a git repository URL both accepted under that one
key, che recognising which it was given rather than asking me to declare it,
so that the catalog's publishing mechanism is not my vocabulary to learn.

### The default source naming the catalog's real home (tested)

I want an unset `packages.source.url` to resolve to the `konradodwrot/che-packages`
registry, the same catalog the embedded copy was built from,
so that the default and the builtin never disagree about which catalog this is.

### Holding a host to an exact catalog version (tested)

I want `packages.source.ref` to name a published version, che fetching exactly
that and nothing newer,
so that a spec pinning its catalog installs the same definitions every run.

### A git-published catalog held to a branch, tag or commit (todo)

I want `packages.source.ref` against a git repository to name a branch, a tag or
a commit, che cloning exactly that,
so that a git catalog pins as precisely as a published one.

### Reading the conditions off the config (tested)

I want the keys under `autoUpdate.if` to name when their contents apply
(`refIsLatest`, `dryRunIsTrue`), not merely that a condition exists,
so that a cooldown under a floating ref is obviously the only cooldown there is.

## As an operator

Runs che on a real host. Installs it, does not build it.

### The newest catalog without asking for it (implemented)

I want `packages.autoUpdate.enabled` to default to true, an unpinned run
resolving the newest published catalog before installing,
so that a host is current without me remembering to update it.

### One update check per che run, whatever the spec holds (tested)

I want the check to happen once per che execution, not once per profile,
so that a ten-profile apply makes one round-trip, not ten.

### A pinned run never waiting on a cooldown (tested)

I want the cooldown to apply only while the ref floats, a pinned ref fetching
its exact version with no cooldown short-circuit,
so that asking for a known version always gets that version.

### A dry run that works with the network gone (tested)

I want `autoUpdate.if.dryRunIsTrue.enabled` to decide whether a dry run checks
for updates at all, defaulting to true,
so that planning offline is a config choice rather than an unavoidable failure.

### A failed fetch never being fatal (implemented)

I want a failed check to warn and fall through to the cached, then embedded,
catalog in every mode including dry run,
so that a dead registry costs a warning, never a run.

<!-- [<] 🤖🤖 -->
