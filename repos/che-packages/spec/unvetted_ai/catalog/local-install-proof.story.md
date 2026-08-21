# Feature: One Package Provable Locally, On a Named Platform

<!-- [>] 🤖🤖 -->

`make test-install PACKAGE=jq` runs one package in a fresh container,
`TARGET_ARCH` picks amd64 or arm64. Neither names an OS: the arch goes straight
to `docker run --platform linux/<arch>`, so linux is not a default but an
assumption baked into the line that starts the container.

That breaks the day the catalog must prove a darwin package. darwin arm64 is
not another `--platform` value, it needs a different virtualisation engine. A
`TARGET_ARCH=all` would be worse than the gap: it reads as "everything" and
means "both linux arches".

So the axis splits. `TARGET_OS` and `TARGET_ARCH` together name one platform,
each explicit. linux runs as today. darwin has a name, no engine yet, and says
so. CI passes the same two variables to the same target, so a matrix job and a
local run differ only in values.

Companion spec: [the catalog repo](own-repo.story.md).

## As a catalog maintainer

Edits `packages.yml` and its install scripts. Writes no Go, owns no schema.

### Naming the platform a package is proven on (implemented)

I want `TARGET_OS` and `TARGET_ARCH` selecting the platform together, each
naming exactly one,
so that asking for a platform never means "some platforms" or silently linux.

### Proving one package on the arch that broke it (implemented)

I want to pick a package and an arch and get its install and verify commands
run in a fresh container,
so that reproducing an arm64-only failure costs no pipeline.

### An unproven platform saying so (implemented)

I want a platform with no virtualisation engine failing by name, never falling
through to another platform's engine,
so that a darwin request cannot pass by running on linux.

### The host's own platform as the default (implemented)

I want an unset `TARGET_OS` meaning the host che-packages runs on,
so that the common local case needs no variable.

## As a pipeline maintainer

Owns the install matrix and its runner cost. Owns neither catalog content nor
che's installer code.

### CI and a local run being the same command (implemented)

I want matrix jobs calling the same make target with the same two variables and
no test logic of their own,
so that a green pipeline and a green local run prove the same thing.

### The matrix still generated from the catalog (implemented)

I want per-package jobs still following `packages.yml`,
so that the os axis does not bring back a hand-listed job set.

### Matrix drift fails before merge (todo)

I want a stale rendered matrix failing the docs-generation check,
so that a catalog edit never merges with a job set behind it.

<!-- [<] 🤖🤖 -->
