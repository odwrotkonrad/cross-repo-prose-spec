# Feature: git wrappers report a skip apart from real work

<!-- [>] 🤖🤖 -->

## As an operator

Fans wrappers over many repos, reads exit codes and the last log line, not
transcripts.

### A repo with nothing to commit is machine-readably skipped (implemented)

I want a clean tree after `git add .` printing `nothing to commit, skipping` and
exiting 24, distinct from 0 and from any failure, no llm call, no commit,
so that a fan-out tells "skipped" from "shipped" without parsing logs.

### Stashed work in a skipped repo surfaces (implemented)

I want a non-empty `git stash list` in a skipped repo printing a
`⚠️ stash: <n> entries` warning then the stash lines as the last log output,
nothing when the stash is empty,
so that stashed work is never mistaken for nothing left to do.

### Exit codes are a stable contract (implemented)

I want `22` sync conflict, `23` already merged, `24` skipped, a third class
beside pass and fail, each wrapper's `#>[what]` header listing its exit codes,
so that callers branch on numbers, not prose.

## As an agent

Runs the full flow unattended, must neither stop on a no-op nor invent work.

### The full flow skips only when nothing happened (implemented)

I want `git-upsert-all.zsh` exiting 24 when every step was a no-op, a 24 from
`git-commit-upsert.zsh` meaning "no commit made" so branch naming and MR upsert
still run, exit 22 short-circuiting,
so that a clean tree off main still gets its branch named and its MR upserted.

### A branch is never named before the commit that names it (implemented)

I want `git-branch-name-upsert.zsh` on main with uncommitted changes printing
`no commits, committing first` and handing off to `git-commit-upsert.zsh`, which
calls back with `GIT_WRAPPER_COMMITTED=1` so the handover happens once,
so that a branch name describes real work, never the clock.

### Nothing to name is a skip, not an invented name (implemented)

I want an empty naming range (`origin/main..HEAD` on main, `main..HEAD` off it)
exiting 24 with `no commits to name`, `git-mr-upsert.zsh` passing that through
and reporting `on main, nothing to MR`, no `tmp/scratch-<datetime>` branch ever
created,
so that no placeholder branch outlives the run.

### The name suggester refuses an empty range (implemented)

I want `llm-git-branch-name-suggest.zsh` logging `no commits in <range>, nothing
to name` and exiting 1, no llm call, no name emitted,
so that a caller's contract violation fails loudly instead of leaking a scratch
name.

<!-- [<] 🤖🤖 -->
