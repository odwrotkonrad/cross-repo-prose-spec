# Feature: che Version Resolution in CI

<!-- [>] 🤖🤖 -->

`ci/zsh/scripts/installs/00-ci-deps.zsh` picks which che a CI job installs.
Merge request pipelines prefer the newest che prerelease from a still-open
go-modules merge request, so a che change gets exercised against configs before
it is tagged. Everything else, and every failure along the way, resolves the
newest released `che/v*` tag.

Scenario: a configs merge request exercises an unmerged che change
  Status: implemented
  Given a go-modules merge request is open and published a `0.0.0-mr<iid>` prerelease
  When a configs pipeline runs with `CI_PIPELINE_SOURCE` of `merge_request_event`
  Then it installs that prerelease instead of the newest released tag
  And with several such prereleases it takes the one created most recently

Scenario: a merged or closed merge request stops leaking its prerelease into later runs
  Status: implemented
  Given prereleases exist in the registry for merge requests no longer open
  When a configs merge request pipeline resolves a che version
  Then it keeps only versions whose `<iid>` appears among go-modules' open merge requests
  And with none left open it resolves the newest released `che/v*` tag

Scenario: main pipelines and local runs keep installing released che
  Status: implemented
  Given the pipeline is not a merge request pipeline
  When che version resolution runs
  Then it resolves the newest released `che/v*` tag
  And it queries neither the packages list nor the merge request list

Scenario: a developer's local dev build survives any CI bootstrap
  Status: implemented
  Given the installed che reports version `dev`
  When che version resolution runs
  Then it keeps the existing binary and installs nothing
  And it prints that it kept the local dev build

Scenario: a che prerelease never reddens a pipeline that is not about che
  Status: implemented
  When any prerelease lookup fails, times out, or returns output it cannot parse
  Then resolution falls back to the newest released tag instead of exiting non-zero
  And when the prerelease install itself fails, it retries once with the released tag
  And an unsupported platform such as `linux/arm64` takes that same fallback

Scenario: a surprising CI result is diagnosable from the job log alone
  Status: implemented
  When che version resolution finishes
  Then it logs the chosen version and why, naming the merge request for a prerelease
  And it logs the fallback and its cause whenever a prerelease was skipped

Scenario: the prerelease preference survives the sudo hop into the CI user
  Status: implemented
  Given the linux jobs run `make sync-full` through `sudo -u $CI_USER --preserve-env=...`
  When che version resolution runs under that user
  Then `CI_PIPELINE_SOURCE` is among the preserved variables
  And the prerelease is reachable, instead of silently resolving the released tag every time

Scenario: the lookup needs no credentials
  Status: implemented
  Given go-modules is a public project
  When resolution lists packages and open merge requests
  Then both calls succeed unauthenticated, with no token plumbed into the job

<!-- [<] 🤖🤖 -->
