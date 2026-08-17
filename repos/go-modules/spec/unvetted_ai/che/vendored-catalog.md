# Feature: che Consumes a Pinned External Catalog

<!-- [>] 🤖🤖 -->

Once `packages.yml` moves to `konradodwrot/che-packages`, che stops owning the
data and starts depending on it. The dependency has to be pinned, not floating:
a build must be reproducible, and a catalog change must never silently alter
what a che build embeds or what che's own tests assert against.

che keeps the installer engine (`che/internal/packages`, the apt/brew/nix/go/npm
/gem/pyenv/nvm/script/binariesRemoteArchive/buildFromSource drivers) and it
keeps the per-*method* e2e proof. What leaves is the catalog data and the
per-*package* matrix. The split follows the failure modes: a method breaks when
this repo's code changes, a package breaks when an upstream registry moves.

Companion specs: [the catalog repo](../../../../che-packages/spec/unvetted_ai/catalog/own-repo.md),
[e2e install methods](../../vetted_title_only/che/e2e-install-methods.md).

## The pin

Scenario: a che build embeds an exactly known catalog
  Status: todo
  Given the catalog version is pinned in this repo at a semver tag or commit sha
  When che builds
  Then it fetches that exact catalog version and embeds it
  And two builds of the same che commit embed byte-identical catalog data
  And a newer catalog release does not change what an unchanged che commit builds

Scenario: taking a newer catalog is a reviewable change
  Status: todo
  When the pinned version is raised
  Then the change is visible in this repo's history as an edit to the pin
  And the pipeline that runs on it tests che against the catalog it will actually ship

Scenario: a fresh host installs packages with no network round-trip for definitions
  Status: todo
  Given a freshly installed che and no cached catalog
  When the operator runs `che packages install`
  Then the embedded catalog serves the definitions
  And no fetch from the catalog repo is required for the install to proceed

Scenario: the fetched catalog outranks the embedded one
  Status: todo
  Given a cached catalog fetched by `che packages update`
  When packages install
  Then the cached catalog is used over the embedded one
  And an explicitly passed packages file supersedes both

Scenario: che looks for catalog updates where the catalog now lives
  Status: todo
  When `che packages update` runs with no override
  Then it resolves versions against the `konradodwrot/che-packages` package registry
  And a fetch failure warns and falls through to the cached or embedded catalog rather than failing the install

## What stays behind

Scenario: proving an install method works stays with the code that implements it
  Status: todo
  When this repo's pipeline runs
  Then the per-method install e2e suite still runs here, over its curated per-method package subset
  And a change to an installer driver is caught by this repo's own pipeline, before any catalog is involved

Scenario: method tests exercise the catalog che will actually ship
  Status: todo
  When the method e2e suite selects packages
  Then it reads the catalog at the pinned version
  And a package the suite names but the pinned catalog lacks fails the run rather than silently skipping

Scenario: the per-package matrix is gone from this repo
  Status: todo
  When a pipeline is created here
  Then no per-package install job and no per-platform package-install stage appears
  And no pipeline rule, release job, module list or workspace entry still names a `che-packages` Go module
  And this repo's generated docs and agent files no longer describe one

Scenario: the packages schema stays authored where the models are
  Status: todo
  Given the schema is generated from this repo's Go models
  When it is regenerated
  Then it is published for the catalog repo to validate against
  And the catalog repo consumes the published schema rather than carrying its own copy of the truth

<!-- [<] 🤖🤖 -->
