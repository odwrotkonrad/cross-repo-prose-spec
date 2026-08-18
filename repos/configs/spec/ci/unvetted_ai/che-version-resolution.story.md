# Feature: che Version Resolution in CI

<!-- [>] 🤖🤖 -->

`ci/zsh/scripts/installs/00-ci-deps.zsh` picks which che a CI job installs.
Merge request pipelines prefer the newest che prerelease from a still-open
go-modules merge request, so a che change gets exercised against configs before
it is tagged. Everything else, and every failure along the way, resolves the
newest released `che/v*` tag.

## As a che maintainer

Changes che, needs it proven against configs before tagging a release.

### An unmerged che change is exercised against configs (implemented)

I want a configs merge request pipeline to install the newest `0.0.0-mr<iid>`
prerelease from an open go-modules merge request,
so that a che change is validated before it becomes a tag.

### A closed merge request stops dictating che versions (implemented)

I want prerelease candidates filtered down to `<iid>`s still open in
go-modules, falling back to the newest released tag when none remain,
so that abandoned work never pins a later pipeline.

## As a CI maintainer

Owns pipeline reliability, does not own che's release cadence.

### Released che everywhere it belongs (implemented)

I want non merge request runs to resolve the newest released `che/v*` tag
without querying packages or merge requests,
so that main pipelines and local runs stay predictable and cheap.

### A che prerelease never reddens an unrelated pipeline (implemented)

I want every lookup failure, timeout, parse error, unsupported platform such as
`linux/arm64`, and failed prerelease install to fall back to the released tag,
retrying the install once,
so that a pipeline about something else survives che's prerelease machinery.

### The prerelease preference survives the sudo hop (implemented)

I want `CI_PIPELINE_SOURCE` preserved through
`sudo -u $CI_USER --preserve-env=...` into `make sync-full`,
so that the prerelease is reachable instead of silently resolving to the
released tag every time.

### No credentials in the version lookup (implemented)

I want the package list and open merge request list read unauthenticated from
public go-modules,
so that no token is plumbed into the job.

## As a developer

Runs the CI bootstrap locally, builds che from source.

### A local dev build survives any CI bootstrap (implemented)

I want resolution to keep the existing binary and install nothing when the
installed che reports version `dev`, printing that it did so,
so that a local build is never clobbered mid session.

### A surprising result is diagnosable from the log alone (implemented)

I want the chosen version logged with its reason, naming the merge request for
a prerelease and the cause whenever a prerelease was skipped,
so that no rerun is needed to explain the version installed.

<!-- [<] 🤖🤖 -->
