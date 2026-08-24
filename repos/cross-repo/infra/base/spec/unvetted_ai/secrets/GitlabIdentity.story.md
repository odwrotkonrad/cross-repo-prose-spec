# Feature: Every GitLab identity is scoped to what it writes

<!-- [>] 🤖🤖 -->

The group tree had one shape of credential: a group access token. Tagging a
repo, emitting an event and cloning a source all used one, so a token minted to
push a tag to `notes` could push a tag to every project in the group, and a
token published to every repo carried whatever the widest consumer needed.

The rule that replaces it is that scope follows what the credential *writes*,
not who reads it. A capability acting on one project is a project access token
minted on that project, however many repos hold it. Only a capability that
genuinely spans the tree is a group token. Publishing a token widely is then
safe on its own terms: what it reaches is narrow regardless of who holds it.

A token's name is the whole of what a token list shows, and that list is read
when something has already gone wrong. So the name carries the four things
worth knowing: `<scope>-<purpose>-[protected|unprotected]-<read|read-write>`.

## As an infra operator

Mints every identity. Decides what each one reaches.

### Mint a per-project token for a per-project capability (todo)

I want tagging and event-emitting to use `gitlab_project_access_token` on the
project each acts on, rather than one group token shared by all of them,
so that a leaked tagging credential tags the repo it leaked from and no other,
and a leaked emit credential reaches one project's pipelines.

### Keep group tokens for capabilities that span the tree (todo)

I want the sandbox, automation and remote-sources identities to stay group
access tokens,
so that a credential which genuinely must clone any repo or open an MR anywhere
is not faked by minting one token per project.

### Publish a narrow token widely rather than a wide token narrowly (todo)

I want the event-emitting token published as a group variable while remaining a
project token on `cross-repo/automation`,
so that every repo can emit without any repo holding a credential that reaches
more than the receiver.

### Name a token for what it reaches (todo)

I want every token named
`<scope>-<purpose>-[protected|unprotected]-<read|read-write>`,
so that the token list answers what subtree it reaches, who holds it, which
branches see it and what it may do, none of which `tag-minter` or
`sandbox-rw-nodelete` said.

### Give each token the weakest role that works (todo)

I want reporter where a fetch only clones, developer where a push only touches
unprotected refs, and maintainer only where a tag or a merge must land on a
protected branch,
so that the role is a statement about the work rather than a margin for
whatever the identity might later be asked to do.

### Cut api to read_api wherever writing is only to git (todo)

I want the sandbox and remote-sources tokens scoped `read_api`, keeping
`write_repository` where a push is needed,
so that a credential that exists to move commits cannot also write to every
other part of the API.

## As a pipeline author

Reads a credential from a variable. Never chooses its scope.

### Read one bare name whichever half arrives (todo)

I want the protected and unprotected halves of an identity pair to remap to the
same bare name at the pipeline boundary,
so that a job reads one name and GitLab decides which value it gets from the
branch it runs on.

### Get a variable only where something reads it (todo)

I want no CI variable minted for an identity whose consumer reads it another
way, as the sandbox reads its token from Secret Manager at image build,
so that the set of CI-visible credentials stays the set CI actually uses.

### Fail loudly when a credential is absent (todo)

I want a job whose token variable expands empty to fail naming the cause,
so that an unset credential is not read as the 404 that an anonymous GitLab
call returns.

## As a security reviewer

Audits what exists against what is declared.

### Find no token that terraform does not declare (todo)

I want every access token and every credential variable in GitLab to exist in
this repo's config, and the duplicates left by earlier runs revoked,
so that the live set and the declared set are the same set, and a stale
credential cannot outlive the identity it was minted for.

### Rotate by applying, not by hand (todo)

I want a rotation to be `terraform taint` plus an apply, rewriting the
consumer's variable in the same run,
so that a new credential and its readers move together, with no window where a
variable names a revoked token.

<!-- [<] 🤖🤖 -->
