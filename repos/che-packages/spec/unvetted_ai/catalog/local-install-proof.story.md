# Feature: One Package Provable Locally, On a Named Platform

<!-- [>] 🤖🤖 -->

`make test-install PACKAGE=jq` already runs one package in a fresh container,
and `TARGET_ARCH` already picks amd64 or arm64. What it cannot express is an
operating system. The arch is passed straight to `docker run --platform
linux/<arch>`, so linux is not a default that could be overridden, it is an
assumption baked into the one line that starts a container.

That assumption holds until the catalog has to prove a darwin package. darwin
arm64 is not another `--platform` value: it needs a different virtualisation
engine entirely, and no amount of arch selection reaches it. A single
`TARGET_ARCH=all` would be worse than the gap, quietly meaning "both linux
arches" while reading as "everything".

So the axis splits. `TARGET_OS` and `TARGET_ARCH` name a platform between them,
each selection explicit and each one platform. linux runs where it runs today.
darwin has a name and no engine yet, and says so, which is the honest state and
a place to add one. CI passes the same two variables to the same target, so a
matrix job and a local run differ in their values alone.

Companion spec: [the catalog repo](own-repo.story.md).

## As a catalog maintainer

Edits `packages.yml` and its install scripts. Writes no Go, owns no schema.

### Naming the platform a package is proven on (todo)

I want `TARGET_OS` and `TARGET_ARCH` to select the platform together, each
naming exactly one,
so that asking for a platform never means "some platforms" and never silently
means linux.

### Proving one package on the arch that broke it (todo)

I want to select a package and an architecture and get that install and its
verify commands in a fresh container,
so that reproducing an arm64-only failure costs no pipeline.

### An unproven platform saying so (todo)

I want a platform with no virtualisation engine wired to fail naming itself,
never falling through to another platform's engine,
so that a darwin request cannot pass by having run on linux.

### The host's own platform as the default (todo)

I want an unset `TARGET_OS` to mean the host che-packages is running on,
so that the common local case needs no variable at all.

## As a pipeline maintainer

Owns the install matrix and its runner cost. Owns neither catalog content nor
che's installer code.

### CI and a local run being the same command (todo)

I want matrix jobs to invoke the same make target with the same two variables,
carrying no test logic of their own,
so that a green pipeline and a green local run prove the same thing.

### The matrix still generated from the catalog (todo)

I want the per-package jobs to keep following `packages.yml`, with drift failing
the docs-generation check,
so that adding the os axis does not reintroduce a hand-listed job set.

<!-- [<] 🤖🤖 -->
