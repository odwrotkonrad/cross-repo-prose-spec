# Feature: Every Repo Declares Its Artifacts

<!-- [>] 🤖🤖 -->

A repo publishes things other repos consume, and consumes things other repos
publish. `.repo/` states both, and the direction is in the name: `downstream`
is what this repo publishes, `upstream` what it consumes. Neither is a list of
repos.

An artifact is a versioned addressable thing, defined by `type`, `uri` (where
it is published, and its identity) and `versionEnvVar` (the CI variable
carrying its version).

Four files carry this, all tracked:

- `.repo/downstream.yml`, what this repo publishes, carrying its own
  `version`. Stays a `.tpl` where the release pipeline injects that version.
- `.repo/upstream.yml`, what this repo consumes. Static, hand-authored, and
  carries no `version` field at all.
- `.repo/upstream.env`, a `KEY=VALUE` lockfile of the versions this repo
  currently holds, one line per `versionEnvVar`. Automation bumps it by MR.
- `.repo/deps-graph.yml`, `dependsOn:` keyed by this repo's own artifacts.

## As a repo owner

Declares what this repo publishes and depends on. Maintains no list of other
repos.

### Read the direction off the file name (implemented)

I want `upstream` to mean what I consume and `downstream` what I publish, in
the file name and the root key alike,
so that which way an edge points needs no explaining.

### Say what an artifact is once (implemented)

I want `type` and `versionEnvVar` written once per artifact beside its `uri`,
so that a moved registry or renamed variable is one edit, not a sweep.

### Address an artifact by where it lives (implemented)

I want the `uri` to be the artifact's identity, with no separate key to invent
or keep in sync,
so that two repos declaring one artifact agree by construction instead of by
reconciliation.

### Publish several artifacts from one repo (implemented)

I want each artifact to carry its own `uri` and `version`,
so that a repo building four things is ordinary rather than a special case.

### Declare what my artifact is built from (implemented)

I want `dependsOn:` keyed by my own artifact, listing the upstreams it is
built from,
so that I state a fact I own and can check locally, never an upstream's blast
radius.

### Say outright that nothing rebuilds an artifact (implemented)

I want an empty list to mean no upstream rebuilds it, distinct from the
artifact being absent and undeclared,
so that "nothing depends on this" is a decision on the page, not an omission.

### Keep the version in exactly one place (implemented)

I want an `upstream.yml` entry to carry no `version` field, the version living
only in `.repo/upstream.env` keyed by `versionEnvVar`,
so that "what do I hold" has one answer and structure edits never touch it.

### See in `git log` when this repo moved (implemented)

I want `.repo/upstream.env` tracked, so a bump is a commit,
so that when a repo adopted a version is a question the history answers,
rather than one only the live CI variables can.

### Prepare a checkout with no token (implemented)

I want a fresh clone to render its `.env` from the tracked lockfile,
so that preparing a checkout needs no `glab` and no GitLab credential.

## As an agent editing a repo

Reads the declarations before changing anything.

### Know which files are mine to write (implemented)

I want `.repo/upstream.env` written by automation's regen MRs and the
declarations hand-authored,
so that I never hand-edit a version that the next regen overwrites.

### Fail loudly on an undefined artifact (implemented)

I want a downstream, upstream or `dependsOn` entry naming a `uri` no repo
publishes to fail, naming both,
so that a typo is caught at declaration rather than at use.

<!-- [<] 🤖🤖 -->
