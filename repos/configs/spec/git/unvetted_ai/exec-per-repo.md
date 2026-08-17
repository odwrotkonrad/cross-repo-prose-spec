<!--[>] 🤖🤖 -->
Feature: exec-per-repo.zsh

Scenario: fans a command out over every repo under a directory
  Status: implemented
  Given repos nested at any depth under a root directory
  When I run `exec-per-repo.zsh [-C <dir>|--chpwd=<dir>] <command> [args...]`
  Then repos are discovered recursively from `<dir>` (default pwd) by their `.git` entry (dir or worktree file)
  And `<dir>` itself being a repo is included, named by its basename
  And the command runs once per repo in a background subshell, cwd set to the repo, all repos concurrent
  And each repo's stdout+stderr is captured to `~/.local/state/git-wrappers/exec-per-repo/<run pid>/<relative path, / → __>_<repo pid>.log`, one dir per invocation, the repo pid self-named by the subshell
  And captured logs end plain text: `NO_COLOR=1 CLICOLOR=0 TERM=dumb` exported, remaining ANSI escapes stripped in place when the repo finishes
  And `GIT_WRAPPER_FG=1` is exported so git-*-upsert wrappers mirror their log into the capture

Scenario: arbitrary command with arguments
  Status: implemented
  When I run `exec-per-repo.zsh -C <dir> git status -sb`
  Then everything after the options runs verbatim as `<cmd> [args...]` in each repo

Scenario: a single quoted argument runs as a shell line
  Status: implemented
  When I run `exec-per-repo.zsh "sleep 1; echo 123 | tr 1 9"`
  Then the lone argument executes as `zsh -c <arg>` in each repo, so `;`, pipes, `&&`, globs work
  And invocations with more than one command word still run verbatim

Scenario: interactive progress dashboard refreshes in place
  Status: implemented
  Given stderr is a terminal
  When repos run
  Then a bold `## Progress <done>/<count> <status> <clock> pid=<run pid> <bar>` header shows overall state: 🕐 while running, then ✅ or ❌, clock = total elapsed, run pid = the exec-per-repo process (the log dir name)
  And the bar (`▱▱▱▱▱` → `▰▰▰▰▱`) fills once per second toward the next tail refresh, updated in place on the header line, dropped on the final frame
  And each repo renders as a bold `### <repo> 🕐 pid=<pid>` block, the repo name right-padded to the longest repo + 2 so status columns align: `log: <log file>`, then `tail: > <most recent log line carrying a letter>` on one line (last 15 lines scanned bottom-up, CR/ANSI stripped, width-truncated, `tail: >` when none qualifies), so block heights stay fixed across redraws
  And a pending repo carries no clock of its own: every repo starts with the run, so a per-repo elapsed would restate the header's, off only by sub-second drift
  And the dashboard redraws in place every 5s (state polled every 1s), clearing the previous frame, the final frame stays on screen

Scenario: a finished repo leaves the live region and settles above it
  Status: implemented
  Given repos finishing at different times
  When one finishes
  Then its block is flushed once above the live region, carrying its own `<clock>`
    (its real runtime, which now differs from the run's) and its final ✅/⏭️/❌
  And it drops out of the live region, so `## Progress` lists only repos still running
  And the header's `<done>/<count>` agrees with the blocks below it, rather than
    counting completions the body no longer shows
  So a long fan-out stays short on screen: settled work scrolls up, attention sits on what remains

Scenario: the relayed tail line is one a human can read
  Status: implemented
  Given a repo whose newest log lines are decoration (box rules, separators, blank)
  When its `tail: >` renders
  Then lines without a single alphabetic character are skipped and the scan continues upward
  And the first line carrying a letter is relayed, so `╰───────╯` never stands in for the outcome
  And a log of pure decoration relays nothing rather than a rule

Scenario: non-interactive progress appends full frames
  Status: implemented
  Given stderr is not a terminal
  When repos run
  Then the same `## Progress` frame as interactive appends every 5s, each after the previous, no screen clearing
  And ANSI bold, the countdown bar, and width truncation are dropped, so redirected logs stay plain text
  And a finished repo's block appears in exactly one frame (the first after it finished), later frames list running repos only, matching the interactive flush

Scenario: summary report closes the run, failures only
  Status: implemented
  When all background runs finish
  Then a bold `## Done <succeeded>/<count> <✅|❌> <clock> ✅ <n> ⏭️ <n> ❌ <n>` line closes the run, same shape as the Progress header, below the `## Passed` and `## Skipped` sections that name the repos behind those counts
  And failures follow under a bold `## Failed Executions` section, each as a bold `### <repo> ❌ (exit N) <M>m<SS>s` block: `log: <log file>`, `tail:` + the log's 10 most recent lines as blockquotes
  And the script exits 0 when nothing failed, 1 otherwise

Scenario: repos that skipped are listed apart from repos that did real work
  Status: implemented
  Given a fanned-out command that exits 24 to mean "skipped, nothing to do" (the git-*-upsert wrappers)
  When the run finishes with at least one skip
  Then skipped repos render ⏭️, not ✅ or ❌, in the live `## Progress` blocks
  And a skip never flips the overall status to ❌, in the header or the final line
  And a bold `## Skipped <n>/<count> ⏭️` section prints above `## Done`, one
    `### <repo padded> ⏭️ <most recent non-empty log line>` per skipped repo, same
    padding as the Progress blocks
  And the `## Done` line counts all three classes: `✅ <n> ⏭️ <n> ❌ <n>`, ✅ excluding skips
  And skipped repos never appear under `## Failed Executions`
  And the script exits 0 when only skips and successes occurred, 1 only on real failures
  So a fan-out over many repos reads as progress, not a wall of identical ✅

Scenario: repos that did real work are named, not just counted
  Status: implemented
  Given a run where at least one repo exits 0
  When the summary renders
  Then a bold `## Passed <n>/<count> ✅` section prints above `## Skipped`, one
    `### <repo padded> ✅ <most recent log line carrying a letter>` per passed repo,
    the same shape and padding as `## Skipped`
  And it names which repos succeeded, where the `## Done` line only counts them
  And a run with no passes prints no `## Passed` section
  So "✅ 3" is answerable from the summary alone, no logs reopened

Scenario: a skipped repo holding stashed work carries its warning into the summary
  Status: implemented
  Given a skipped repo whose wrapper printed a `⚠️ stash: <n> entries` warning
  When the `## Skipped` section renders
  Then that warning is the relayed log line, since it is the repo's last non-empty output
  So parked work is visible from the summary alone, no per-repo log opening

Scenario: --include/--exclude select repos by name or path
  Status: implemented
  When I run with `--include=a,b` and/or `--exclude=c,d`
  Then a token containing `/` matches the repo path relative to the root exactly
  And a bare token matches the repo directory basename
  And include empty means all repos, exclude is applied after include
  And a basename matching more than one discovered repo exits 2, listing the candidates

Scenario: --must-filter targets repos needing attention, AND semantics
  Status: implemented
  When I run with `--must-filter=changes,off-main,unsynced` (any subset)
  Then only repos satisfying every listed condition run:
  And `changes`: `git status --porcelain` non-empty (tracked or untracked)
  And `off-main`: current branch is not `main`
  And `unsynced`: no upstream, or ahead/behind counts vs `@{u}` differ from `0 0`

Scenario: bad invocation exits 2 with usage
  Status: implemented
  When I pass an unknown option, or no command after the options
  Then usage prints on stderr and the script exits 2

SubFeature: exec-per-repo.zsh completions

Scenario: first positional arg completes via the deep command engine
  Status: implemented
  Given the `_exec-per-repo` completion file is on fpath
  When I complete the first positional arg
  Then the deep `-command-` engine offers scripts, aliases, builtins, functions, commands, fuzzy-filtered and capped
  And no files or dirs are offered
  And option offers stop once the command position is reached

Scenario: words after the command complete as the inner command's own
  Status: implemented
  When I complete a word after the command, e.g. `exec-per-repo.zsh git chec<TAB>`
  Then the remaining words re-dispatch as their own command line (`checkout` offered)

Scenario: root dir options complete deep dirs
  Status: implemented
  When I complete `-C <TAB>` or `--chpwd=<TAB>`
  Then the deep files engine offers dirs only (`file-types dirs` on the `_deep_files` context)
  And accepting a match keeps the `--chpwd=` prefix on the line (`compadd -i "$IPREFIX"` alongside `-U` in the engine)

Scenario: --include/--exclude complete discovered repos
  Status: implemented
  When I complete `--include=<TAB>` or `--exclude=<TAB>`
  Then discovered repos are offered as root-relative paths, comma-separated appendable
  And the root is taken from `-C`/`--chpwd=` already on the line, default pwd
  And discovery mirrors the script: `.git` entries pruned recursively, the root itself by basename

Scenario: --must-filter completes its filter values
  Status: implemented
  When I complete `--must-filter=<TAB>`
  Then `changes`, `off-main`, `unsynced` are offered comma-separated

Scenario: stock compsys options are restored despite sticky autoload
  Status: implemented
  Given completion functions autoload sticky-emulated (`emulate zsh -LRc`), resetting options like `extendedglob`
  When the completion function or its repo helper runs
  Then it restores `$_comp_options` via `setopt localoptions`, so called compsys functions see standard completion options
<!--[<] 🤖🤖 -->
