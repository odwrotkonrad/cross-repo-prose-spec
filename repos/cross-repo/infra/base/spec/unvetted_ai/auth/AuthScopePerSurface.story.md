# Feature: Each principal's reach is designed per surface

<!-- [>] 🤖🤖 -->

Four surfaces grant access independently: GitLab, GitHub, GCP and 1Password. A
principal's reach is decided on each one separately, because a grant that is
harmless on one is not on another.

Two grants are cut here. The sandbox held `secretmanager.admin`, which let a
compromised pod create and destroy secrets when all it ever needed was to read
its own; it becomes a read-only custom role. Its GitLab token held full `api`,
which is write access to everything the group exposes; it becomes `read_api`,
keeping `write_repository` so branches and MRs still work.

Merging a green MR stays possible for the sandbox. GitLab has no scope that
opens an MR without merging it, so the control is a protected-branch rule
requiring approval, which is a later change and not this one.

## As an infra operator

Designs each principal's reach, surface by surface.

### Cut the sandbox to read-only Secret Manager (todo)

I want the sandbox's `secretmanager.admin` replaced by a read-only custom role
on the auth project,
so that an inspected pod can fetch the credentials it runs on and can neither
create a secret nor delete one.

### Narrow the sandbox's GitLab token to `read_api` (todo)

I want the group access token's scopes cut from `api` to `read_api`, keeping
`write_repository` and `read_repository`,
so that the pod still pushes branches and opens MRs while losing write access
to every other GitLab API.

### Keep the sandbox's project-level Secret Manager grant (todo)

I want the read-only grant scoped to the auth project rather than per secret,
so that a secret added later is readable with no new binding, which is the one
property the over-broad role had that is worth keeping.

### Give CI no GitHub reach at all (todo)

I want no GitHub credential bound to any CI identity, mirrors being created by
me,
so that a pipeline compromise reaches nothing on GitHub.

### Let each repo release under its own token (todo)

I want each repo's CI to hold its own protected project access token for
releasing, plus protected access to the automation token for emitting events,
so that a repo's pipeline releases itself without a credential that reaches
another repo.

### Keep merge rights on the branch rule, not the token (todo)

I want the sandbox's ability to merge constrained later by a protected-branch
approval rule rather than by its token scopes,
so that the control lands where GitLab actually enforces it instead of being
claimed by a scope list that cannot express it.

<!-- [<] 🤖🤖 -->
