# Feature: git wrappers report a skip apart from real work

<!-- [>] 🤖🤖 -->

Scenario: a repo with nothing to commit is machine-readably skipped, not silently passed (implemented)
  Given a repo clean after `git add .`
  When I run `git-commit-upsert.zsh`
  Then it prints `nothing to commit, skipping`
  And exits 24, the skip code, distinct from 0 (committed) and from any failure
  And requests no llm commit message, makes no commit

Scenario: stashed work in a skipped repo surfaces instead of hiding behind a clean tree (implemented)
  Given a repo skipped for nothing to commit
  And a non-empty `git stash list`
  When the skip is reported
  Then a `⚠️ stash: <n> entries` warning prints, then the `git stash list` lines
  And the warning is the last log line, so a fan-out tail relays it verbatim
  And an empty stash prints no warning

Scenario: a branch is never named before the commit that gives it its name (implemented)
  Given main with uncommitted changes and no commits ahead of `origin/main`
  When I run `git-branch-name-upsert.zsh`
  Then it prints `no commits, committing first` and hands off to `git-commit-upsert.zsh`
  And commit-upsert calls back with `GIT_WRAPPER_COMMITTED=1`, so the handover
    happens at most once
  And the branch name derives from the commit that now exists

Scenario: nothing to name is a skip, not an invented name (implemented)
  Given a clean tree with no commits in the naming range
    (`origin/main..HEAD` on main, `main..HEAD` off it)
  When I run `git-branch-name-upsert.zsh`
  Then it exits 24 with `no commits to name`, making no branch
  And `git-mr-upsert.zsh` passes that 24 through, not as a failure,
    then reports `on main, nothing to MR`
  And no `tmp/scratch-<datetime>` branch is ever created

Scenario: the name suggester refuses an empty range instead of guessing (implemented)
  Given `llm-git-branch-name-suggest.zsh` called with a range holding no commits
  When it resolves its template vars
  Then it logs `no commits in <range>, nothing to name` and exits 1
  And makes no llm call, emits no name

<!-- [<] 🤖🤖 -->
