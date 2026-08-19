# Feature: Semver Tagging Per Repo

<!-- [>] 🤖🤖 -->

A che include can pin a version only if the source repo has one. Prose and the
package catalog mint tags; the rest do not, so a consumer pins prose at a ref and
takes `control` from an unpinned branch. Every repo mints `vX.Y.Z` on merge to
its default branch, patch by default, a `semver: major|minor|patch` commit token
lifting it. The flow is prose's, authored once and shared.

A tag is the whole deliverable. A release object belongs to a repo that ships
binaries or is explicitly a public consumable, and the two repos that do already
carry their own release flows. Nothing here gains one, and an ephemeral CI job
artifact is not a shipped deliverable.

## As a repo consumer

Pins a remote che include or a template ref. Reads no branch to find a version.

### Pin any repo I depend on (todo)

I want every repo carrying semver tags,
so that an include names a version instead of tracking a moving branch.

### Take a dependency on a merge as soon as it lands (todo)

I want a merge to the default branch minting the next tag with no manual step,
starting at `v0.0.1`,
so that anything merged is immediately pinnable.

## As a repo maintainer

Merges changes and lets CI mint. Pushes no tag by hand.

### Routine change ships as a patch (todo)

I want the bump to default to patch,
so that ordinary growth never inflates a version.

### Signal a larger change deliberately (todo)

I want a `semver: major|minor|patch` commit token to decide the bump, the largest
token winning,
so that a breaking or feature-level change is marked by intent, not inferred.

### A stale local tag decides nothing (todo)

I want the last tag read from the remote,
so that the minted tag follows the remote's latest, not a clone's.

### Re-running on a tagged commit mints nothing (todo)

I want an already-tagged HEAD to report and exit clean,
so that a re-run never collides with an existing tag.

### A tag pipeline repeats no validation (todo)

I want tag pipelines skipping the pre-commit validation the merge already passed,
so that minting costs one job.

### Tagging is a named target, shared not copied (todo)

I want the next-version and mint steps as Makefile targets over scripts authored
once in prose and consumed at a pinned ref,
so that the same invocation runs locally and no repo carries its own copy.

### No repo gains a release it does not ship (todo)

I want minting to create a tag only, never a release object,
so that a Releases page means a shipped artifact wherever it is non-empty.

## As a repo owner

Grants CI the reach to push a tag, no credential beyond that.

### Minting identity is declared, not clicked (todo)

I want one group-level tagger identity in terraform, exposing a masked and
protected token variable per project it must tag,
so that adding a repo to the flow is a declared change, not a console visit.

### Branch protection admits the minter (todo)

I want each default branch's protection permitting the tagger to push tags and
nothing further,
so that minting works without widening what CI may do.

<!-- [<] 🤖🤖 -->
