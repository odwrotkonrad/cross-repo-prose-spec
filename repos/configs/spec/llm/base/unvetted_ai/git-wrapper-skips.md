<!--[>] 🤖🤖 -->
Feature: git wrappers report a skip apart from real work

Scenario: a repo with nothing to commit is machine-readably skipped, not silently passed
  Status: todo
  Given a repo whose tree is clean after `git add .`
  When I run `git-commit-upsert.zsh`
  Then it prints `nothing to commit, skipping`
  And it exits 24, the skip code, distinct from 0 (committed) and from any failure
  And no llm commit message is requested, no commit is made
  So a fan-out wrapper tells "skipped" from "shipped" without parsing logs

Scenario: stashed work in a skipped repo surfaces instead of hiding behind a clean tree
  Status: todo
  Given a repo skipped for having nothing to commit
  And `git stash list` is non-empty
  When the skip is reported
  Then a `⚠️ stash: <n> entries` warning prints, followed by the `git stash list` lines
  And the warning is the last log line, so a fan-out tail relays it verbatim
  And an empty stash prints no warning
  So work parked in a stash is never mistaken for a repo with nothing left to do

Scenario: the full flow reports a skip only when nothing at all happened
  Status: todo
  When I run `git-upsert-all.zsh`
  Then its existing no-op guard (clean tree, on main, main == origin/main) exits 24
  And a 24 from `git-commit-upsert.zsh` means "no commit made", not "stop": the
    branch-name and MR steps still run, so a clean tree off main or unsynced still
    gets its branch named and its MR upserted
  And the flow exits 24 only when every step was a no-op, else 0
  And exit 22 (sync conflicts) still short-circuits the flow

Scenario: exit codes stay a stable contract across the wrappers
  Status: todo
  Then `22` = sync conflicts, `23` = already merged, `24` = skipped, nothing to do
  And `24` is not a failure: callers treat it as a third class beside pass and fail
  And each wrapper's `#>[what]` header lists the codes it can exit with
<!--[<] 🤖🤖 -->
