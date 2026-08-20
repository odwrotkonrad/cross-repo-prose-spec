# Feature: Semver Tagging Per Repo

<!-- [>] 🤖🤖 -->

A che include can pin a version only if the source repo mints one. Prose and
the package catalog do, the rest do not, so a consumer pins prose at a ref and
takes `control` from a moving branch. Every repo mints `vX.Y.Z` on merge to its
default branch, patch by default, a `semver: major|minor|patch` commit token
lifting it. The flow is prose's, authored once and shared.

A tag is the whole deliverable. A release object belongs to a repo shipping
binaries or an explicit public consumable, and the two repos that do already
have their own release flows. Nothing here gains one. An ephemeral CI job
artifact is not a shipped deliverable.

## As a repo consumer

Pins a remote che include or template ref. Reads no branch to find a version.

### Pin any repo I depend on (implemented)

I want every minting repo carrying `vX.Y.Z` tags, go-modules its
`<module>/vX.Y.Z`,
so that an include names a version instead of tracking a branch.

### iac and sandbox join the tagging flow (todo)

I want infra/iac and infra/sandbox in `tagging_projects` with the shared
tag-mint job, oci-images pinning iac's lock file at a tag,
so that no repo is consumable only from a branch.

### Depend on a merge as soon as it lands (implemented)

I want a merge to the default branch minting the next tag with no manual step,
starting at `v0.0.1`,
so that anything merged is immediately pinnable.

## As a repo maintainer

Merges, lets CI mint. Pushes no tag by hand.

### Routine change ships as a patch (implemented)

I want the bump to default to patch,
so that ordinary growth never inflates a version.

### Signal a larger change deliberately (implemented)

I want a `semver: major|minor|patch` commit token to decide the bump, largest
token winning,
so that a breaking or feature-level change is marked by intent, not inferred.

### Local copies give way to the shared targets (todo)

I want che-packages, go-modules and oci-images minting through `semver-next`
and `tag-mint` rendered from prose, gaining the `semver:` token and the
already-tagged guard their own scripts lack,
so that one flow carries every rule here.

### A stale local tag decides nothing (implemented)

I want the last tag read from the remote,
so that the minted tag follows the remote's latest, not a clone's.

### Re-running on a tagged commit mints nothing (implemented)

I want an already-tagged HEAD to report and exit clean,
so that a re-run never collides with an existing tag.

### Minting spends no CI beyond the mint (implemented)

I want a pushed tag to start no pipeline where none is wanted, and where tag
pipelines do run, to skip the validation the merge already passed,
so that a release costs one job and never re-checks merged content.

### Tag pipelines skip validation everywhere (todo)

I want che-packages' `validate-catalog` and oci-images' pre-commit job excluded
from tag pipelines,
so that a mint there re-checks nothing the merge already passed.

### Tagging is a named target, shared not copied (implemented)

I want the next-version and mint steps as Makefile targets over scripts
authored once in prose and consumed at a pinned ref,
so that the same invocation runs locally and no repo carries its own copy.

### No repo gains a release it does not ship (implemented)

I want minting to create a tag only, never a release object,
so that a non-empty Releases page always means a shipped artifact.

## As a repo owner

Grants CI the reach to push a tag, nothing more.

### Minting identity is declared, not clicked (implemented)

I want one group-level tagger identity in terraform, exposing a masked,
protected token variable per project it tags,
so that adding a repo to the flow is a declared change, not a console visit.

### Branch protection admits the minter (implemented)

I want each tagging project's protection letting the tagger push tags,
so that minting works without a console visit.

### The minter reaches tags and nothing further (todo)

I want a `v*` tag protection admitting the tagger alone, its token scoped no
wider,
so that a leaked token mints tags and cannot push a branch.

<!-- [<] 🤖🤖 -->
