# Feature: One Place Carries Versions Between Repos

<!-- [>] 🤖🤖 -->

Repos consume each other's releases: go-modules embeds the che-packages
catalog, every repo renders prose at a pinned tag, images bake a che build.
Each is a version written down in the consumer, and each must move when the
producer publishes.

prose works this way: a tag fans out one regen MR per affected repo, the pin
rises there, the consumer's CI proves the new version before merge. Nothing
else did. The catalog pin sat at `0.0.4` while the catalog shipped `0.0.7`,
pointing at a registry the catalog had left, because nothing watched and nobody
had reason to look.

Pinning is deliberate: a build embeds an exactly known version, and adopting a
newer one is a reviewable change that runs the consumer's tests first. The gap
is that nothing moves the pin. That belongs in automation: it owns the
dependency graph, knows who consumes what, opens the MRs.

A pin also belongs in a file of its own, read where needed, not repeated at
each use. One line to change, one place to look, no consumer quietly
disagreeing with another about the current version.

## As a consumer repo owner

Pins producers' versions and builds against them. Does not track their release
streams.

### A pin is one line in one file (implemented)

I want the version declared in its own file, read by everything that needs it,
never inline in a script, pipeline or Makefile,
so that knowing or changing it is one edit in one place.

### A commit's output never changes under it (implemented)

I want the build to fetch and embed exactly the declared version, whatever the
producer published since,
so that two builds of one commit are byte-identical.

### A bump proves itself before adoption (implemented)

I want the pin-bump MR to run the consumer's own tests against the new version,
merging without a human when green,
so that a breaking bump leaves a red MR, not a broken default branch.

### Every pin in the repo moves together (implemented)

I want a bump to raise every pin of that producer wherever it is written,
so that a pin in an unexpected file is not silently left behind.

### Disagreeing pins are reported (todo)

I want two pins of one producer at different versions named in the run's
report,
so that a drifted pin is seen, not overwritten unnoticed.

### Every released artifact version is carried to iac, published as a variable (implemented)

I want each producer release (a prose tag, a che-packages tarball, an image) to
reach `infra/iac` through automation as one MR bumping that artifact's tfvars
line, iac publishing it as a `GRP_KO_VAR_<ARTIFACT>_REF` group variable holding
the latest version,
so that every artifact's current version has one home, GitLab variables always
name the latest, and no consumer carries a pin to sed.

### The applied variable drives the consumers (todo)

I want iac's main apply to report the variables it changed as a
`ci-var.changed` event, automation answering with one content regen per
consumer of each changed variable's producer, rendered at the value the
variable now holds,
so that a consumer never renders ahead of the variable it reads and nothing
polls for the moment it moves.

### A che release is carried like every other artifact (todo)

I want a che tag to reach iac as a tfvars bump published as a group variable,
so that consumers pin che through the same mechanism as prose and the catalog.

## As a workspace maintainer

Owns automation's graph and fan-out. Keeps no hand-written consumer lists.

### A publish reaches every consumer automatically (implemented)

I want automation to open a pin-bump MR against every repo the graph says
consumes the producer, and none other,
so that correctness never depends on remembering the consumer list.

### A stale pin is reported, not discovered by failure (implemented)

I want the prose pin named with the latest tag whenever it lags,
so that staleness surfaces before a consumer breaks on missing content.

### Every producer's stale pin is named, a moved registry included (todo)

I want the gap named (repo, pin, version available) for every producer when
automation evaluates the graph, including a pin aimed at a registry or project
the producer has left,
so that no catalog or image pin rots unseen.

### The consumer list follows declarations alone (implemented)

I want a repo's own interface file to decide what it receives, overriding any
seed,
so that onboarding a consumer needs no edit inside automation.

### Dropping a consumer needs no edit inside automation (todo)

I want the seeds gone once every repo declares itself,
so that removing an interface file drops a consumer and no seed resurrects it.

<!-- [<] 🤖🤖 -->
