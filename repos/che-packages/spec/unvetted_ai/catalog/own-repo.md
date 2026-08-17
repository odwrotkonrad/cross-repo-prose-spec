# Feature: The Package Catalog Lives in Its Own Repo

<!-- [>] 🤖🤖 -->

`packages.yml` is data: 1203 lines describing what to install and how, per
manager, per platform. Today it sits inside a Go monorepo as `che-packages/`, a
module whose entire Go content is one `//go:embed` directive. Every catalog
edit — a version bump, a new package, a changed apt name — enters through
`go.work`, a `go.mod`, a Makefile with no-op `build`/`install`/`release-check`
targets, and a pipeline whose `changes:` rules must name `che-packages/**/*` in
eight places.

Proving the catalog works costs more still. `che/e2e/install_methods_test.go`
is 837 lines of Go serving two unrelated purposes: proving each *install
method* works, and proving each *catalog package* installs. The second drives
three GitLab stages and a per-package matrix across three platforms. Those two
concerns change for different reasons — a method breaks when che's installer
code changes, a package breaks when an upstream registry moves — and they now
fail together.

Splitting the catalog out gives it its own release cadence, its own tag stream
and its own test suite in a language suited to orchestrating containers and
asserting shell output. che keeps the engine and the per-method proof, and
consumes the catalog at a version it pins.

## What the repo owns

Scenario: the catalog is editable without a Go toolchain
  Status: todo
  Given a contributor wants to add a package or bump a pinned version
  When they clone `konradodwrot/che-packages`
  Then the change is an edit to `packages.yml` and nothing else
  And no `go.mod`, `go.work` entry, embed directive or Go build stands between the edit and the merge
  And the repo's own pipeline is what validates it

Scenario: the catalog and its install scripts travel together
  Status: todo
  When the repo publishes a release
  Then the artifact carries `packages.yml` and the `scripts/` tree referenced by its `script` entries
  And a consumer that unpacks it has everything an install needs

Scenario: a malformed catalog is caught before anyone tries to install from it
  Status: todo
  Given the packages schema published by che
  When any merge request touches `packages.yml`
  Then a fast automatic job validates the file against that schema
  And it fails on an unknown field, a missing required field or a wrong type
  And this job needs no container, no docker and no real install

Scenario: an entry that can never install is caught without installing it
  Status: todo
  When the fast validation job runs
  Then every entry resolves to at least one installation method on at least one supported platform
  And every entry's verify commands derive successfully from its declaration
  And an entry whose verify strategy cannot produce a command fails the job

## Proving packages install

Scenario: every catalog package is provably installable on every method it declares
  Status: todo
  Given a package entry declaring one or more installation methods
  When the install suite runs for that package
  Then each declared method eligible for the target platform installs it for real, from real registries and archives
  And each install is followed by the verify commands derived from the entry
  And a method that installs but produces nothing runnable fails

Scenario: a maintainer tests one package locally before pushing
  Status: todo
  Given docker on the maintainer's machine
  When they select a single package, or a single package and method, on the command line
  Then only that install and verify runs
  And it runs in a fresh container, never against the maintainer's own machine
  And the failure output names the method, the install command and the verify command that failed

Scenario: every install runs isolated so packages never contaminate each other
  Status: todo
  When the install suite runs
  Then every (package, method) case gets its own fresh debian container
  And nothing installed or pulled in by one case is visible to another
  And a package that only appears to work because a previous case installed its dependency fails here

Scenario: a package already present in the base image never masks a broken method
  Status: todo
  Given che reports that a package was already present rather than installed
  When a case produces that report
  Then the case is not counted as a pass
  And the run says the method never actually ran

Scenario: the suite reuses download caches without weakening isolation
  Status: todo
  When cases rerun
  Then apt archives, apt lists and che-downloaded assets come from a cache shared across runs
  And the container itself stays bare: only che and the package's declared base prerequisites
  And a cached asset whose checksum no longer matches is discarded rather than used

## Pipeline

Scenario: both supported linux architectures are proven, and only those
  Status: todo
  When a pipeline runs the install suite
  Then linux amd64 and linux arm64 are both covered
  And arm64 cases run on arm64 runners, not under emulation
  And no macOS runner and no local VM manager is involved

Scenario: the per-package matrix is generated from the catalog, never hand-listed
  Status: todo
  When a pipeline is created
  Then it carries one job per package in `packages.yml`, per architecture
  And adding a package to the catalog adds its jobs with no pipeline edit
  And a hand-edited job list that has drifted from the catalog fails the docs-generation check

Scenario: the install matrix never starves other repos' pipelines
  Status: todo
  Given these jobs need docker-in-docker and flood a shared runner queue
  When a merge-request pipeline is created
  Then the per-package install jobs are manual and optional
  And untriggered jobs never block the pipeline
  And a triggered job that fails never blocks the merge on its own

Scenario: a maintainer narrows a triggered job to one method at trigger time
  Status: todo
  Given a manual per-package job
  When the maintainer sets a method variable while triggering it
  Then only that method's install and verify runs
  And leaving it unset runs every method the entry declares

## Publishing and consumption

Scenario: a tagged catalog is fetchable at an exact version forever
  Status: todo
  When a version tag is pushed
  Then the pipeline publishes a versioned tarball with a sha256 checksum to the repo's package registry
  And it links both as release assets
  And that exact version stays fetchable after later releases

Scenario: a running che can pick up catalog updates without a new che
  Status: todo
  Given a host with che installed
  When the catalog publishes a newer version
  Then the moving `latest` alias and its version marker resolve to it
  And `che packages update` fetches it into the cache
  And installs use the fetched catalog over the one built into che

Scenario: a catalog release reaches the binaries that embed it
  Status: todo
  When the catalog publishes a release
  Then a downstream build is triggered to re-vendor and re-release che
  And an operator who upgrades che gets the newer catalog without a manual fetch

<!-- [<] 🤖🤖 -->
