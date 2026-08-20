# Feature: Local Sync of Generated Outputs

<!-- [>] 🤖🤖 -->

A local watcher keeps generated files fresh in local worktrees. On a new prose
tag it re-renders, per checkout, only untracked outputs. Tracked files change
through regen MRs alone.

## As a developer

Works in local worktrees, runs no render commands by hand.

### Have my gitignored outputs follow prose releases (implemented)

I want the watcher to re-render them in place on a new prose tag,
so that my worktree matches the release without me running anything.

### Trust the watcher never to touch tracked files (implemented)

I want tracked render outputs left alone,
so that their updates arrive only as reviewable regen MRs.

### Get a clean no-op in a worktree without a prose pin (implemented)

I want the watcher to change nothing and report the repo unpinned,
so that unrelated checkouts stay untouched.

<!-- [<] 🤖🤖 -->
