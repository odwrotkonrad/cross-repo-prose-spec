# Feature: exec-per-repo.zsh

<!-- [>] 🤖🤖 -->

Scenario: arbitrary command with arguments (implemented)
  When I run `exec-per-repo.zsh -C <dir> git status -sb`
  Then everything after the options runs verbatim as `<cmd> [args...]` in each repo

Scenario: a single quoted argument runs as a shell line (implemented)
  When I run `exec-per-repo.zsh "sleep 1; echo 123 | tr 1 9"`
  Then the lone argument executes as `zsh -c <arg>` in each repo, so `;`, pipes, `&&`, globs work
  And invocations with more than one command word still run verbatim

Scenario: --include/--exclude select repos by name or path (implemented)
  When I run with `--include=a,b` and/or `--exclude=c,d`
  Then a token containing `/` matches the repo path relative to the root exactly
  And a bare token matches the repo directory basename
  And include empty means all repos, exclude is applied after include
  And a basename matching more than one discovered repo exits 2, listing the candidates

Scenario: --must-filter targets repos needing attention, AND semantics (implemented)
  When I run with `--must-filter=changes,off-main,unsynced` (any subset)
  Then only repos satisfying every listed condition run:
  And `changes`: `git status --porcelain` non-empty (tracked or untracked)
  And `off-main`: current branch is not `main`
  And `unsynced`: no upstream, or ahead/behind counts vs `@{u}` differ from `0 0`

Scenario: bad invocation exits 2 with usage (implemented)
  When I pass an unknown option, or no command after the options
  Then usage prints on stderr and the script exits 2

Scenario: summary report closes the run, failures only (implemented)
  When all background runs finish
  Then a bold `## Done <succeeded>/<count> <✅|❌> <clock> ✅ <n> ⏭️ <n> ❌ <n>` line closes the run, same shape as the Progress header, below the `## Passed` and `## Skipped` sections that name the repos behind those counts
  And failures follow under a bold `## Failed Executions` section, each as a bold `### <repo> ❌ (exit N) <M>m<SS>s` block: `log: <log file>`, `tail:` + the log's 10 most recent lines as blockquotes
  And the script exits 0 when nothing failed, 1 otherwise

<!-- [<] 🤖🤖 -->
