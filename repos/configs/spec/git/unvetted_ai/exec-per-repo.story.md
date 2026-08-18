# Feature: exec-per-repo.zsh

<!-- [>] 🤖🤖 -->

## As a workspace maintainer

Owns many repos at once, runs the same operation across all of them, does not
visit them one by one.

### One command reaches every repo under a directory (implemented)

I want repos discovered recursively from `-C <dir>` (default pwd) by their
`.git` entry, the root itself included by basename, each running the command
concurrently in its own subshell with cwd set to the repo, output captured to
`~/.local/state/git-wrappers/exec-per-repo/<run pid>/<path>_<repo pid>.log` as
plain text with `GIT_WRAPPER_FG=1` exported,
so that a fan-out costs one invocation and leaves a readable trail per repo.

### Arbitrary commands run verbatim (implemented)

I want everything after the options executed as `<cmd> [args...]` in each repo,
so that any tool fans out, not a fixed list.

### A quoted one-liner runs as a shell line (implemented)

I want a lone argument executed as `zsh -c <arg>` so `;`, pipes, `&&` and globs
work, while multi-word invocations still run verbatim,
so that a composed shell snippet needs no wrapper script.

### Repo selection by name or path (implemented)

I want `--include=a,b` and `--exclude=c,d` matching a root-relative path when
the token holds `/` and a directory basename otherwise, exclude applied after
include, an ambiguous basename exiting 2 with the candidates listed,
so that a subset runs without editing the tree.

### Only repos needing attention run (implemented)

I want `--must-filter=changes,off-main,unsynced` requiring every listed
condition: dirty `git status --porcelain`, branch not `main`, or missing
upstream / non-zero ahead-behind against `@{u}`,
so that a sweep touches the repos with real state, not all of them.

### A bad invocation fails immediately (implemented)

I want an unknown option or a missing command printing usage on stderr and
exiting 2,
so that a typo never fans out.

## As an operator

Watches a long fan-out live, judges it from the terminal, opens logs only when
something breaks.

### Live state without scrolling (implemented)

I want a bold `## Progress <done>/<count> <status> <clock> pid=<run pid> <bar>`
header over one fixed-height block per running repo, name-padded, carrying
`log:` and a `tail: >` line, the bar filling once per second and the frame
redrawing in place every 5s over polled state,
so that the run's state is one glance, not a scroll.

### Finished work settles above the live region (implemented)

I want a finished repo flushed once above the live region with its own clock
and final ✅/⏭️/❌, dropping out of `## Progress` so the header count agrees
with the blocks below it,
so that a long fan-out stays short on screen and attention sits on what remains.

### The relayed tail line is readable (implemented)

I want the last 15 lines scanned bottom-up, lines without an alphabetic
character skipped, nothing relayed for a log of pure decoration,
so that `╰───────╯` never stands in for the outcome.

### Redirected output stays plain (implemented)

I want the same `## Progress` frame appended every 5s when stderr is not a
terminal, without bold, countdown bar, width truncation or screen clearing, a
finished repo's block appearing in exactly one frame,
so that a piped or logged run reads as a transcript.

### The summary answers the run without reopening logs (implemented)

I want a bold `## Done <succeeded>/<count> <✅|❌> <clock> ✅ <n> ⏭️ <n> ❌ <n>`
line below `## Passed` and `## Skipped`, failures under `## Failed Executions`
as `### <repo> ❌ (exit N) <M>m<SS>s` with `log:` and the 10 newest lines
quoted, exit 0 when nothing failed and 1 otherwise,
so that the verdict and the reason arrive together.

### Skips read apart from real work (implemented)

I want exit 24 rendered ⏭️, never flipping the run to ❌, listed in a bold
`## Skipped <n>/<count> ⏭️` section with each repo's newest non-empty log line,
counted separately in `## Done`, absent from `## Failed Executions`,
so that a fan-out reads as progress instead of a wall of identical ✅.

### Passing repos are named, not just counted (implemented)

I want a bold `## Passed <n>/<count> ✅` section above `## Skipped`, one padded
line per passed repo carrying its newest lettered log line, omitted when nothing
passed,
so that "✅ 3" is answerable from the summary alone.

### Parked work in a skipped repo surfaces (implemented)

I want a wrapper's `⚠️ stash: <n> entries` warning relayed as the skipped repo's
log line,
so that stashed work is visible without opening a log.

## As a developer

Types the command at the prompt, wants the shell to fill in the rest.

### The command position completes real commands (implemented)

I want the first positional arg served by the deep `-command-` engine offering
scripts, aliases, builtins, functions and commands, fuzzy-filtered and capped,
with no files or dirs and no further option offers,
so that the word that matters completes like a command line.

### Words after the command complete as that command's own (implemented)

I want the remaining words re-dispatched as their own command line, so
`exec-per-repo.zsh git chec<TAB>` offers `checkout`,
so that wrapping a tool costs nothing in completion quality.

### Options complete their own values (implemented)

I want `-C`/`--chpwd=` offering dirs only through the deep files engine while
keeping the `--chpwd=` prefix on the line, `--include=`/`--exclude=` offering
discovered repos as comma-appendable root-relative paths taken from the root
already typed, and `--must-filter=` offering `changes`, `off-main`, `unsynced`,
so that no option value is typed from memory.

### Completion behaves under sticky autoload (implemented)

I want `$_comp_options` restored via `setopt localoptions` in the completion
function and its repo helper,
so that called compsys functions see standard completion options despite
`emulate zsh -LRc`.

<!-- [<] 🤖🤖 -->
