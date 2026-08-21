# Feature: Cross-Repo MR Prerelease Preference

<!-- [>] 🤖🤖 -->

Dependent MRs across repos pick up each other's results before merge. An open
MR whose prerelease stage passes publishes a prerelease. Downstream MRs prefer
it over the latest release.

## As an upstream repo owner

Produces artifacts other repos consume. Does not control when downstreams
integrate.

### Buildable results are shareable before merge (implemented)

I want a passing prerelease stage on an open MR to publish its artifacts under
a prerelease version, discoverable by the MR it came from,
so that downstream work starts before my merge.

## As a downstream repo owner

Consumes upstream artifacts in an MR pipeline. Picks no versions by hand.

### Unmerged upstream work is testable now (implemented)

I want dependency resolution to prefer an open upstream MR's prerelease over
the latest release,
so that a coupled change across two repos is provable before either merges.

### Unverified upstream work is never picked up (implemented)

I want a fallback to the latest release when the upstream MR is closed, merged,
or its prerelease stage has not passed,
so that a downstream pipeline never builds on a failure.

<!-- [<] 🤖🤖 -->
