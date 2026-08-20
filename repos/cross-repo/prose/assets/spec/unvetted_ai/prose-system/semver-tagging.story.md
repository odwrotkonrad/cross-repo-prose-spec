# Feature: Prose Semver Tagging

<!-- [>] 🤖🤖 -->

Every merge to main mints one semver tag `vX.Y.Z`, patch bump. Prose grows by
adding files, so an add is not a release event: only a
`semver: major|minor|patch` commit token lifts a release above patch. The last
tag comes from the remote, never the local clone.

## As a prose author

Merges prose changes, never mints or pushes a tag by hand.

### Ship a merged change without a manual release step (implemented)

I want the tag job to mint and push the next `vX.Y.Z` on every commit to main,
starting at `v0.0.1`,
so that anything merged is immediately consumable.

### Ship routine prose as a patch (implemented)

I want adds, edits and deletes to bump the patch by default,
so that ordinary growth never inflates the version.

### Lift a release above patch when warranted (implemented)

I want a `semver: major|minor|patch` commit token to decide the bump, largest
token winning,
so that I signal a breaking or feature-level change deliberately.

### Keep a stale local tag out of the decision (implemented)

I want the last tag read from the remote,
so that the minted tag follows the remote's latest, not my clone's.

<!-- [<] 🤖🤖 -->
