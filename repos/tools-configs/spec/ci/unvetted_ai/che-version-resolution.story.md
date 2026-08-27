# Feature: che Version Resolution in CI

<!-- [>] 🤖🤖 -->

`ci/zsh/scripts/installs/00-ci-deps.zsh` picks the che a CI job installs. MR
pipelines prefer the newest che prerelease from an open go-modules MR, so a che
change runs against configs before it is tagged. Everything else, and every
failure on the way, resolves the newest released `che/v*` tag.

## As a che maintainer

Changes che, needs it proven against configs before tagging.

### An unmerged che change runs against configs (implemented)

I want a configs MR pipeline installing the newest `0.0.0-mr<iid>` prerelease
from an open go-modules MR,
so that a che change is validated before it becomes a tag.

### A closed MR stops dictating che versions (implemented)

I want prerelease candidates filtered to `<iid>`s still open in go-modules,
the newest released tag when none remain,
so that abandoned work never pins a later pipeline.

## As a CI maintainer

Owns pipeline reliability, not che's release cadence.

### Released che everywhere else (implemented)

I want non-MR runs resolving the newest released `che/v*` tag without querying
MRs or prereleases,
so that main pipelines and local runs stay predictable and cheap.

### A che prerelease never reddens an unrelated pipeline (implemented)

I want every lookup failure, timeout, parse error, unsupported platform
(`linux/arm64`) and failed prerelease install falling back to the released tag,
the install retried once,
so that a pipeline about something else survives che's prerelease machinery.

### The prerelease preference survives the sudo hop (implemented)

I want `CI_PIPELINE_SOURCE` preserved through
`sudo -u $CI_USER --preserve-env=...` into `make sync-full`,
so that the prerelease is reachable instead of silently falling back every
time.

### No credentials in the version lookup (implemented)

I want the package list and open MR list read unauthenticated from public
go-modules,
so that the lookup needs no token.

## As a developer

Runs the CI bootstrap locally, builds che from source.

### A local dev build survives the CI bootstrap (implemented)

I want resolution keeping the existing binary, installing nothing and saying
so, when the installed che reports version `dev`,
so that a local build is never clobbered mid-session.

### A surprising result is diagnosable from the log (implemented)

I want the chosen version logged with its reason, the MR named for a
prerelease,
so that no rerun is needed to explain the installed version.

### A skipped prerelease names its cause (todo)

I want the skip line saying which: MR list failed, package list failed, no
open MR had a prerelease,
so that a fallback is explained without rerunning the job.

<!-- [<] 🤖🤖 -->
