# Feature: Installable che Prereleases from MR Pipelines

<!-- [>] 🤖🤖 -->

`prerelease-linux-che` and `prerelease-darwin-che` build che at `0.0.0-mr<iid>`
on every merge request touching `che/`, `lib/`, `ci/publish-prerelease.zsh`, the
`Makefile` or `.gitlab-ci.yml`. Each publishes its archives to the generic
package registry from the same job, so a che change is installable before it is
tagged. Linux covers amd64 only, darwin arm64.

## As a che developer

Changes che and wants it installable now. Cuts no tags.

### An unmerged change installs through the published installer (implemented)

I want each prerelease job to upload `che_0.0.0-mr<iid>_<os>_<arch>.tar.gz` to
`packages/generic/che/0.0.0-mr<iid>/`,
so that `CHE_VERSION=0.0.0-mr<iid>` installs it through the unchanged
`install.sh` and `che --version` reports it.

### The publish path is provable on its own merge request (implemented)

I want the prerelease jobs to run for merge requests touching only
`ci/publish-prerelease.zsh`, the `Makefile` or `.gitlab-ci.yml`, absent gate
jobs tolerated through optional `needs`,
so that a change to publishing is tested before it merges.

### A merge request always holds its newest build (implemented)

I want the version keyed on the iid, never the commit, re-uploads replacing the
previous archives,
so that a consumer resolving `0.0.0-mr<iid>` gets the latest build and the
registry accumulates nothing per commit.

## As a pipeline maintainer

Owns the prerelease jobs and their gates. Adds no jobs, no secrets.

### Publishing costs no new job and no new secret (implemented)

I want the upload as the last step of the existing job, authenticated with
`CI_JOB_TOKEN`, reusing the existing retry flags,
so that prereleases add no surface to maintain.

### Gates are every automatic test and nothing slower (implemented)

I want each prerelease job to wait on `test-unit-che` and the automatic
`test-e2e-che-{dryrun,run,backup}` jobs, never on `test-e2e-install-methods`,
`test-e2e-che-registry` or the coverage stage,
so that nothing untested publishes and no manual click or upstream-registry
assertion sits on the critical path.

### Two platform jobs fill one version without racing (implemented)

I want the linux job uploading only from `dist/`, the darwin job only from
`darwin-dist/`, filenames differing by os and arch,
so that neither overwrites the other and a job whose counterpart failed still
publishes.

## As a release consumer

Installs released che. Never wants a prerelease by accident.

### A prerelease never masquerades as a release (implemented)

I want it to link no release assets and leave `packages/generic/che/latest/`
untouched,
so that `install.sh` with no `CHE_VERSION` still resolves the newest real
release.

### Platform coverage is readable (implemented)

I want `linux/amd64` and `darwin/arm64` archives under a prerelease version and
no `linux/arm64`,
so that a consumer knows to fall back to a released tag there.

### Every linux architecture consumers test on is covered (todo)

I want a `linux/arm64` archive built alongside amd64, one job per architecture
as the tag pipeline does, merge-request build caches kept separate from release
caches,
so that `che-packages` can drive a prerelease on both arches it tests.

<!-- [<] 🤖🤖 -->
