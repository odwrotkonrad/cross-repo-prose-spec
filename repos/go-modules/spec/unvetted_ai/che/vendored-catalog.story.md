# Feature: che Consumes a Pinned External Catalog

<!-- [>] 🤖🤖 -->

With `packages.yml` in `konradodwrot/che-packages`, che depends on the catalog
instead of owning it. The dependency is pinned: builds must be reproducible,
and a catalog change must never silently alter what a build embeds or what
che's tests assert against.

che keeps the installer engine (`che/internal/packages`, the apt/brew/nix/go/npm
/gem/pyenv/nvm/script/binariesRemoteArchive/buildFromSource drivers) and the
per-*method* e2e proof. The catalog data and the per-*package* matrix leave.
The split follows failure modes: a method breaks when this repo's code changes,
a package breaks when an upstream registry moves.

Companion specs: [the catalog repo](../../../../che-packages/spec/unvetted_ai/catalog/own-repo.story.md),
[e2e install methods](../../vetted_title_only/che/e2e-install-methods.md).

## As a release maintainer

Owns che's builds and what they embed. Does not own the catalog's contents.

### A build embedding an exactly known catalog (implemented)

I want the catalog pinned at a semver tag or commit sha, che embedding that
exact version, two builds of one commit embedding byte-identical data, a newer
catalog release changing nothing for an unchanged commit,
so that a build is reproducible from its commit alone.

### Taking a newer catalog as a reviewable change (todo)

I want a raised pin to be an edit in this repo's history, its pipeline testing
che against the catalog it will ship,
so that a catalog move is reviewed like any other change.

## As an operator

Installs packages with che on a real host. Does not know where the catalog
lives.

### A fresh host installing with no network round-trip (tested)

I want the embedded catalog to serve `che packages install`, no fetch from the
catalog repo,
so that a freshly installed che works offline.

### The fetched catalog outranking the embedded one (tested)

I want a catalog cached by `che packages update` used over the embedded one, an
explicit packages file over both,
so that updated definitions take effect without rebuilding che.

### Update looking where the catalog now lives (tested)

I want `che packages update` to resolve versions against the
`konradodwrot/che-packages` package registry, a fetch failure warning and
falling back to the cached or embedded catalog,
so that the move is invisible to a host and a dead registry never blocks an
install.

## As a pipeline maintainer

Owns this repo's pipeline and test suites. Does not own the catalog's pipeline.

### Method proofs staying with the code implementing them (implemented)

I want the per-method install e2e suite to keep running here over its curated
package subset, a driver change caught by this pipeline before any catalog is
involved,
so that a failure names the repo that caused it.

### Method tests exercising the catalog che will ship (implemented)

I want the suite to read the catalog at the pinned version, a package it names
but the catalog lacks failing the run instead of skipping,
so that a green suite proves the shipped pairing.

### The per-package matrix gone from this repo (implemented)

I want no per-package install job, no per-platform package-install stage, and no
pipeline rule, release job, module list, workspace entry, generated doc or agent
file still naming a `che-packages` Go module,
so that nothing here still claims to own the catalog.

### The packages schema authored where the models are (implemented)

I want the schema generated from this repo's Go models and published for the
catalog repo to validate against, no copy carried there,
so that one definition of the format exists.

<!-- [<] 🤖🤖 -->
