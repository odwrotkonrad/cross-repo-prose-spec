# Feature: Automation identity provisioned by the auth module

<!-- [>] 🤖🤖 -->

The fan-out that opens and merges regen MRs needs a Maintainer credential and a
name that reads as a machine. The auth module owns both: one group access token
on `konradodwrot`, exposed to the automation project as
`REPO_VAR_CONTROL_GITLAB_TOKEN` and mirrored into Secrets Manager.

The token name is what GitLab shows as the author of every write it makes, so
it names the role: `ko-automation`.

## As a repo historian

Reads MR lists and `git log` to see who did what.

### The identity reads as a machine (implemented)

I want the group access token named `ko-automation`,
so that the author and merger of a regen MR is recognisable as automation and
not mistaken for a person.

## As an infra operator

Applies the auth module. Owns what the token can reach and where its value
lands.

### One token, Maintainer, group-wide (implemented)

I want a single `konradodwrot` group access token at maintainer level
(api, read_repository, write_repository),
so that regen MRs open, arm auto-merge and land on protected `main` without a
second credential.

### The value lands where the run reads it (implemented)

I want the token value written to `REPO_VAR_CONTROL_GITLAB_TOKEN` on the
automation project, masked and protected, and to its Secrets Manager version,
so that renaming the token rotates every consumer in the same apply.

<!-- [<] 🤖🤖 -->
