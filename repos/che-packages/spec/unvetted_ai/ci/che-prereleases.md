# Feature: The Catalog Tests Against Unmerged che

<!-- [>] 🤖🤖 -->

`che-pin.env` names the che this catalog targets, in two halves that are one
coupling: `CHE_VERSION`, the binary the install tests drive, and
`CHE_SCHEMA_REF`, the git ref the packages schema is read from. The rule
between them is that content may use only vocabulary the target che
understands.

That rule makes the ordering strict: che merges and releases new catalog
vocabulary, then the pin rises here, then the catalog may use it. Until the
release, a catalog change that depends on unmerged che vocabulary cannot be
validated or installed at all — it fails here, correctly, with no way to prove
it would pass.

`configs` already solved the same problem for its own pipeline. On a merge
request it prefers an open go-modules MR's `0.0.0-mr<iid>` prerelease over the
newest released tag, treating the lookup as best-effort throughout: a
prerelease is a convenience, never a reason to redden a pipeline that is not
about che. This repo wants that mechanism, and wants it to move both halves of
the pin together, because validating against merged vocabulary while installing
an unmerged binary proves neither.

## Resolving the prerelease

Scenario: a merge request pipeline prefers an open MR's che over the released pin
  Status: todo
  Given a go-modules merge request has published a `0.0.0-mr<iid>` che prerelease
  And that merge request is still open
  When a merge-request pipeline runs in this repo
  Then it drives that prerelease instead of the version named in `che-pin.env`
  And it says which version it chose, and which go-modules merge request it came from

Scenario: pipelines that are not merge requests are untouched
  Status: todo
  When a pipeline runs on the default branch or on a tag
  Then it uses `che-pin.env` exactly as written, resolving no prerelease
  And the pin remains the only thing that decides which che a release is proven against

Scenario: a prerelease belonging to a closed or merged MR is never used
  Status: todo
  Given prereleases persist in the registry after their merge request closes
  When resolution runs
  Then only a prerelease whose merge request is still open is eligible
  And the newest eligible one wins, prereleases being ordered by publication time

Scenario: an iid never matches another iid by prefix
  Status: todo
  Given open merge request `!420` and a stale prerelease `0.0.0-mr42`
  When resolution matches published prereleases against open merge requests
  Then `0.0.0-mr42` is not selected
  And matching is on whole iids, never on substrings of a concatenated list

Scenario: every lookup failure falls through to the pin rather than failing the pipeline
  Status: todo
  Given the resolution talks to the GitLab API
  When any request fails, returns nothing, or no open merge request has a prerelease
  Then the pipeline proceeds on the version in `che-pin.env`
  And it says no prerelease was resolved
  And a pipeline about the catalog is never reddened by a che lookup

## Binary and schema move together

Scenario: the schema comes from the same code as the binary
  Status: todo
  Given a resolved prerelease belongs to a known go-modules merge request
  When the packages schema is fetched
  Then it is read from that merge request's code, not from `main`
  And the vocabulary validated against is the vocabulary the driven binary implements
  And a catalog entry using vocabulary that merge request adds validates here before it merges

Scenario: the schema ref is immutable and survives branch names with slashes
  Status: todo
  Given a merge request's source branch may be renamed, and may contain `/`
  When the schema ref is resolved
  Then it is the merge request's commit sha, not its branch name
  And no URL-encoding of a branch name stands between resolution and the fetch

Scenario: an unresolved prerelease leaves both halves of the pin alone
  Status: todo
  When no prerelease resolves
  Then `CHE_VERSION` and `CHE_SCHEMA_REF` are both the values `che-pin.env` names
  And neither half is moved without the other

## Fetching what was resolved

Scenario: a stale cached binary or schema is never mistaken for the resolved one
  Status: todo
  Given a previous run left a downloaded che binary and schema in place
  When resolution picks a different version than that run used
  Then both are re-fetched rather than reused
  And a bare existence check never stands in for a version check

Scenario: both linux architectures drive the resolved prerelease
  Status: todo
  Given the install suite covers linux amd64 and linux arm64
  When a prerelease is resolved
  Then each architecture's job fetches that prerelease for its own architecture
  And neither architecture silently falls back to a released che while the other runs the prerelease
  And this depends on che publishing a linux arm64 prerelease archive

## Validation actually runs

Scenario: the schema check fails loudly rather than skipping silently
  Status: todo
  Given the catalog validation skips itself when no schema file is present
  When the validation job runs in CI
  Then the schema has been fetched before the check runs
  And a run where the schema could not be fetched fails, rather than reporting success
  And a skipped schema check is never reported as a passing validation

Scenario: the validation job gets the schema the same way a local run does
  Status: todo
  Given a maintainer validates locally through the repo's make targets
  When the validation job runs in CI
  Then it goes through those same targets rather than invoking the test runner directly
  And the job and the local run cannot drift into fetching different things

<!-- [<] 🤖🤖 -->
