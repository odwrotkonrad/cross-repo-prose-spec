# Technical Requirements: GitLab identities

<!-- [>] 🤖🤖 -->

Declared in `cross-repo/infra/base`, `tf/secrets/`. Nothing else in the group
mints a GitLab credential.

## Naming

`<scope>-<purpose>-[protected|unprotected]-<read|read-write>`

`<scope>` is the group path for a group token and the project path with `/`
replaced by `-` for a project token. A token whose name does not parse into
those four parts is drift.

## Scope rule

A capability acting on one project is a `gitlab_project_access_token` minted on
that project, however many repos hold the value. A capability spanning the tree
is a `gitlab_group_access_token`. Reach is decided by what the credential
writes, never by how widely it is published.

## The identities

| token | type | role | scopes |
|---|---|---|---|
| `konradodwrot-sandbox-protected-read-write` | group | developer | `read_api`, `write_repository`, `read_repository` |
| `konradodwrot-automation-protected-read-write` | group | maintainer | `api`, `write_repository`, `read_repository` |
| `konradodwrot-remote-sources-unprotected-read` | group | reporter | `read_api`, `read_repository` |
| `automation-emit-events-protected-read-write` | project (`cross-repo/automation`) | developer | `api` |
| `<repo>-tag-mint-protected-read-write` | project (one per tagging repo) | maintainer | `api`, `write_repository` |

`expires_at` is `token_expires_at` on every one.

## Where each value lands

| token | sink | why |
|---|---|---|
| sandbox | Secret Manager, `konradodwrot-sandbox-auth/sandbox-gitlab-group-token` | the pod has no pipeline to inject a variable; read at image build |
| automation | `REPO_PROTECTED_VAR_BOT_AUTOMATION_GITLAB_TOKEN` on the automation project | the widest-reaching credential in the group, so exactly one project sees it |
| remote-sources | `GRP_KO_UNPROTECTED_VAR_BOT_GITLAB_TOKEN` | every repo renders prose on unprotected branches |
| emit-events | `GRP_KO_PROTECTED_VAR_BOT_EMIT_EVENTS_TOKEN` | every repo emits, only from protected refs |
| tag-mint | `REPO_PROTECTED_VAR_BOT_TAG_TOKEN` on its own project | the variable and the credential have the same reach |

Every variable is `masked = true`. `protected` matches the token's name.

## Masked, not hidden

`hidden` is accepted by GitLab only at creation, so enabling it means destroying
and recreating the variable. For a value every repo reads, that window breaks
all of them at once. Masking redacts job logs, which is the exposure that
matters; hidden is set at the next rotation, not by an in-place edit.

## What is forbidden

- A credential variable in GitLab that no terraform declares, including a bare
  unprefixed name: `GITLAB_TOKEN` at group scope today.
- A second token for a capability that already has one, including the duplicates
  earlier applies left behind.
- `api` where `read_api` plus `write_repository` covers the work.
- A token minted outside `cross-repo/infra/base`.
- Any token value reaching a terraform output, a tfvars entry or a release
  artifact. Only `secrets_hash` derives from secrets, and it is a hash.

<!-- [<] 🤖🤖 -->
