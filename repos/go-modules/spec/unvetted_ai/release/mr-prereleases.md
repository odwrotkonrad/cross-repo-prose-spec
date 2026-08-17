# Feature: Installable che Prereleases from MR Pipelines

<!-- [>] 🤖🤖 -->

`prerelease-linux-che` and `prerelease-darwin-che` already build che at
`0.0.0-mr<iid>` on every merge request touching `che/`, `che-packages/` or
`lib/`. They publish those archives to the generic package registry from within
the same job, so a che change is installable before it is ever tagged.

Scenario: a change to the publish path can be tested before it merges
  Status: implemented
  Given a merge request touching only `ci/publish-prerelease.zsh`, `Makefile` or `.gitlab-ci.yml`
  When the pipeline runs
  Then the prerelease jobs still run and publish
  And the publish path is provable on its own merge request, never only after merging
  And gate jobs absent from such a pipeline are tolerated, since each `needs` is optional

Scenario: a developer installs an unmerged che change without waiting for a release
  Status: implemented
  Given an open merge request touching `che/`, `che-packages/` or `lib/`
  When its `prerelease-linux-che` and `prerelease-darwin-che` jobs succeed
  Then each uploads its own `che_0.0.0-mr<iid>_<os>_<arch>.tar.gz` to `packages/generic/che/0.0.0-mr<iid>/`
  And `CHE_VERSION=0.0.0-mr<iid>` installs it through the unchanged published `install.sh`
  And the installed binary reports `0.0.0-mr<iid>` from `che --version`

Scenario: publishing costs the pipeline no new job and no new secret
  Status: implemented
  When a prerelease job publishes
  Then it uploads as a final step of the existing job, no separate publish job
  And it authenticates with `CI_JOB_TOKEN`, the same header the tag-pipeline publish scripts use
  And it reuses the retry flags the other publish scripts carry

Scenario: a prerelease is gated on every test that runs by itself, and nothing slower
  Status: implemented
  Given a merge request whose prerelease jobs are eligible
  When the pipeline runs
  Then each prerelease job waits on `test-unit-che` and the automatic `test-e2e-che-{dryrun,run,backup}` jobs
  And any of them failing stops the prerelease from publishing
  And it never waits on `test-e2e-install-methods`, whose manual dind matrix would block on a click
  And it never waits on `test-e2e-che-registry`, which asserts upstream package names, not the binary being shipped
  And it never waits on the coverage stage, keeping it off the critical path

Scenario: two platform jobs fill one version without racing each other
  Status: implemented
  Given both prerelease jobs run for the same merge request
  When each publishes into `packages/generic/che/0.0.0-mr<iid>/`
  Then the linux job uploads only from `dist/`, the darwin job only from `darwin-dist/`
  And their filenames differ by os and arch, so neither overwrites the other
  And a job whose counterpart failed still publishes its own platform

Scenario: a merge request holds exactly one prerelease, always its newest build
  Status: implemented
  Given a merge request whose prerelease jobs have already published
  When a later push to that same merge request runs them again
  Then it publishes under the same `0.0.0-mr<iid>` version, keyed on the iid and never on the commit
  And the re-uploaded archives replace the previous ones at those filenames
  And the registry holds one prerelease version per merge request, no per-commit accumulation
  And a consumer that resolved `0.0.0-mr<iid>` earlier now installs the newer build under that same version

Scenario: a prerelease never masquerades as a release
  Status: implemented
  When a prerelease publishes
  Then it links no release assets, because a merge request has no release
  And it leaves the moving `packages/generic/che/latest/` alias untouched
  And `install.sh` with no `CHE_VERSION` still resolves the newest real release

Scenario: an operator reads which platforms a prerelease actually covers
  Status: implemented
  Given `prerelease-linux-che` builds amd64 only and `prerelease-darwin-che` builds arm64
  When a prerelease publishes
  Then `linux/amd64` and `darwin/arm64` archives exist under that version
  And `linux/arm64` has none, so a consumer on that platform must fall back to a released tag

Scenario: a prerelease covers every linux architecture its consumers test on
  Status: todo
  Given `che-packages` runs its install suite on linux amd64 and linux arm64
  And a consumer cannot drive a prerelease on an architecture it was never built for
  When a prerelease publishes
  Then `linux/arm64` has an archive alongside `linux/amd64`
  And both are built the way the tag pipeline already builds them, one job per architecture
  And a merge request's build cache stays separate from the cache a tag release restores
  And this supersedes the platform coverage the preceding scenario records

<!-- [<] 🤖🤖 -->
