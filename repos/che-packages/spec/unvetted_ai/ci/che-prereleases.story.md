# Feature: The Catalog Tests Against Unmerged che

<!-- [>] 🤖🤖 -->

`che-pin.env` names the che this catalog targets, in two halves that are one
coupling: `CHE_VERSION`, the binary the install tests drive, and
`CHE_SCHEMA_REF`, the git ref the packages schema is read from. The rule between
them: content may use only vocabulary the target che understands.

That makes the ordering strict. che merges and releases new catalog vocabulary,
then the pin rises here, then the catalog may use it. Until the release, a
catalog change depending on unmerged che vocabulary cannot be validated or
installed at all. It fails here, correctly, with no way to prove it would pass.

`configs` already solved this for its own pipeline. On a merge request it
prefers an open go-modules MR's `0.0.0-mr<iid>` prerelease over the newest
released tag, treating the lookup as best-effort throughout: a prerelease is a
convenience, never a reason to redden a pipeline that is not about che. This
repo wants that mechanism, and wants it to move both halves of the pin together,
because validating against merged vocabulary while installing an unmerged binary
proves neither.

This is the `go-modules/che` to `che-packages` instance of the workspace policy
in `control`'s Cross-Repo MR Prerelease Preference, resolved against a hardcoded
upstream rather than the dependency graph that spec anticipates.

## As a catalog maintainer

Writes catalog content against a che that may not be released yet. Does not
control che's release cadence.

### New che vocabulary is usable before che is tagged (implemented)

I want a merge-request pipeline to drive an open go-modules MR's
`0.0.0-mr<iid>` prerelease in place of the pinned version, naming what it chose
and which MR it came from,
so that a catalog entry depending on unmerged che vocabulary is provable now.

### Validation and installation agree on one code state (implemented)

I want the schema fetched from the same merge request's code as the driven
binary,
so that the vocabulary checked is the vocabulary the binary implements.

### Both halves of the pin move together or not at all (implemented)

I want `CHE_VERSION` and `CHE_SCHEMA_REF` to stay at their pinned values when no
prerelease resolves,
so that a half-moved pin never proves nothing.

## As a pipeline maintainer

Owns the resolution logic and the install jobs. Owns neither che nor the catalog
content.

### A che lookup never reddens a catalog pipeline (implemented)

I want every API failure, empty result or absent prerelease to fall through to
`che-pin.env` and say so,
so that resolution is a convenience and never a failure mode.

### Releases are proven against exactly what they pin (implemented)

I want default-branch and tag pipelines to resolve no prerelease,
so that the pin alone decides which che a release was proven against.

### Only live, unambiguous prereleases are eligible (implemented)

I want selection restricted to prereleases of still-open merge requests, newest
first, matched on whole iids,
so that a closed MR's leftover, or `0.0.0-mr42` standing in for `!420`, is never
picked.

### The schema ref survives renamed and slashed branches (implemented)

I want the merge request's commit sha used as the ref,
so that no branch-name URL-encoding sits between resolution and the fetch.

### A stale download is never mistaken for the resolved one (implemented)

I want the binary and schema re-fetched whenever resolution differs from the
previous run,
so that an existence check never stands in for a version check.

### Both architectures drive the same resolved binary (implemented)

I want each of linux amd64 and arm64 to fetch the resolved prerelease for its
own architecture,
so that neither silently falls back to a released che while the other does not.

### A skipped schema check never reports success (implemented)

I want the job to fail when the schema could not be fetched, running through the
same make targets a local run uses,
so that validation cannot silently skip itself or drift from local behavior.

<!-- [<] 🤖🤖 -->
