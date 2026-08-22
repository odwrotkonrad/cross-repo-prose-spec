# Feature: Regen Writes Carry the Bot Identity

<!-- [>] 🤖🤖 -->

A regen run writes to GitLab four ways: the commit, the push, the MR, the
merge. Each one stamps a name into history. The machine identity exists (the
`cross-repo-bot` group access token, `CONTROL_GITLAB_TOKEN` in CI), so every
one of those writes belongs to it.

Two leaks made them the user's instead. The commit author read
`GITLAB_USER_NAME` / `GITLAB_USER_EMAIL`, GitLab's predefined variables naming
whoever triggered the pipeline. `glab` resolved its own token from the
environment, config or keyring, so MR creation and the merge call ran as
whatever that happened to be.

The bot's git identity is derived from the token in use (`GET user`), never
hardcoded and never defaulted: an unresolvable identity aborts the run.

## As a repo historian

Reads `git log` and MR lists to see who did what.

### A machine write is never attributed to a person (implemented)

I want the regen commit, its MR and its merge all authored by the bot user,
so that a human name in history means a human did the work.

### The bot's git identity comes from its own token (implemented)

I want the commit author resolved from the authenticated user behind
`CONTROL_GITLAB_TOKEN`, as `<username>` / `<id>-<username>@noreply.gitlab.com`,
so that the name in the log matches the identity that actually pushed.

### An unknown identity stops the run (implemented)

I want the run to abort when the authenticated user cannot be resolved,
never falling back to a hardcoded author,
so that a broken token surfaces instead of quietly mislabelling history.

## As a workspace maintainer

Owns the fan-out scripts and the blast radius of the token they carry.

### One place decides who glab is (implemented)

I want the bot token passed as `GITLAB_TOKEN` at the single helper that builds
every glab call, covering MR creation, stale-MR closing, branch deletion and
both auto-merge paths,
so that no call site can drift back to an ambient identity.

### The token reaches glab and nothing else (implemented)

I want the token scoped to the glab subprocess environment, not exported as a
job-wide CI variable,
so that every other tool in the job runs without it.

<!-- [<] 🤖🤖 -->
