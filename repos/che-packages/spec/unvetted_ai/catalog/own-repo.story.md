# Feature: The Package Catalog Lives in Its Own Repo

<!-- [>] 🤖🤖 -->

`packages.yml` is data: 1203 lines of what to install and how, per manager, per
platform. It sat in a Go monorepo as `che-packages/`, a module whose whole Go
content was one `//go:embed` directive. Every catalog edit (a version bump, a
new package, a changed apt name) went through `go.work`, a `go.mod`, a Makefile
of no-op `build`/`install`/`release-check` targets, and a pipeline whose
`changes:` rules named `che-packages/**/*` in eight places.

Proving the catalog cost more. `che/e2e/install_methods_test.go` was 837 lines
doing two unrelated jobs: proving each *install method* works, and proving each
*catalog package* installs. The second drove three GitLab stages and a
per-package matrix across three platforms. A method breaks when che's installer
changes, a package when an upstream registry moves, and they failed together.

Its own repo gives the catalog its own release cadence, tag stream and test
suite, in a language suited to driving containers and asserting shell output.
che keeps the engine and the per-method proof, and pins the catalog version it
consumes.

## As a catalog maintainer

Edits `packages.yml` and its install scripts. Writes no Go, owns no schema.

### An edit is one YAML change, no Go toolchain in the way (implemented)

I want the catalog in its own repo, validated by its own pipeline,
so that adding a package or bumping a pin touches `packages.yml` only.

### Breakage is caught before a container is ever started (implemented)

I want a fast schema job on every merge request rejecting unknown fields,
missing required fields and wrong types,
so that a malformed catalog never reaches an install job.

### An entry that can never install fails without installing (implemented)

I want validation proving every entry resolves to at least one method on a
supported platform and derives its verify commands,
so that a dead entry is caught by a job that starts no container.

### Vocabulary never outruns the che that must read it (implemented)

I want validation failing with the unknown term named,
so that the fix is obvious: release che first, then raise the pin.

### The failure names the che that rejected it (todo)

I want a vocabulary failure naming the che version whose schema rejected it,
so that the pin to raise is read off the failure, not worked out.

### One package is provable locally before a push (implemented)

I want a command running one package, or one package and method, in a fresh
container,
so that I get the failing install and verify commands without burning a
pipeline.

### A trigger can be narrowed to one method (implemented)

I want a method variable on a manually triggered per-package job,
so that I retry one broken method instead of the entry's whole set.

## As a schema owner

Owns che's installer vocabulary, generated from Go models. Owns no catalog
content.

### The contract has exactly one source of truth (implemented)

I want the catalog fetching che's published `packages.schema.json`, never a
copy committed here,
so that a vocabulary change in che takes effect with no catalog edit.

## As a pipeline maintainer

Owns the install matrix and its runner cost. Owns neither catalog content nor
che's installer code.

### Every install method is proven on every merge request (todo)

I want the first N packages of each method (N configurable, default 2)
installing for real on both arches,
so that a method broken everywhere fails with nobody clicking a job.

### The rest of the catalog stays one click away (implemented)

I want an optional manual job per remaining package per arch, running every
method it declares,
so that full coverage exists without every pipeline paying for it.

### Isolation makes a pass mean something (implemented)

I want each (package, method) case in its own fresh debian container, an
already-present package counted as a failure,
so that no case passes on a dependency another case installed.

### Reruns are fast without weakening isolation (implemented)

I want apt archives, apt lists and che-downloaded assets shared across runs,
checksummed, the container staying bare,
so that caching buys speed, never a false pass.

### Both supported architectures are proven, natively (implemented)

I want linux amd64 and linux arm64 covered on their own runners,
so that arm64 results are real: no emulation, macOS runner or local VM.

### The matrix follows the catalog with no pipeline edit (implemented)

I want one job per package per arch generated from `packages.yml`,
so that no hand-listed job set can fall behind the catalog.

### Matrix drift fails before merge (todo)

I want a stale rendered matrix failing the docs-generation check,
so that a catalog edit never merges with a job set behind it.

### The matrix never starves other repos' runners (implemented)

I want the per-package dind jobs manual, optional and non-blocking on failure,
so that a shared runner queue survives a catalog merge request.

## As a catalog consumer

Installs from a published release: vendors a pinned tarball, or resolves the
moving alias at runtime. Never reads the default branch.

### A release carries everything an install needs (implemented)

I want the artifact holding `packages.yml` plus the `scripts/` tree its
`script` entries reference,
so that unpacking one file is enough to install.

### An exact version stays fetchable forever (implemented)

I want each tag publishing a versioned tarball and sha256 to the package
registry, linked as release assets,
so that a pinned build resolves the same bytes after later releases.

### A newer catalog arrives without a new che (implemented)

I want the moving `latest` alias and its version marker resolving to the newest
release, fetched by `che packages update` and preferred over the embedded copy,
so that catalog fixes ship without a binary upgrade.

### A che upgrade also carries the newer catalog (implemented)

I want a catalog release raising che's catalog pin and offering a downstream
re-vendor,
so that the next che release embeds the newer catalog.

### A catalog release alone ships a new che (todo)

I want the raised pin re-releasing che with no manual trigger,
so that upgrading the binary needs no manual fetch.

<!-- [<] 🤖🤖 -->
