# Feature: Local Workspace Assembly

<!-- [>] 🤖🤖 -->

The `workspace/` che profile assembles the local workspace (canonical home here,
moved from configs' `gitlab/projects`): clones the group tree, links parent
Makefiles and the VS Code workspace file onto the host, generates the
non-checked-out subgroup indexes.

## As a workspace user

Runs the profile on a host. Clones and links nothing by hand.

### A fresh host holds the whole group tree after one run (implemented)

I want the clone script to fetch every non-archived project of each
`$GITLAB_GROUPS` pair into `$WORKSPACE_DIR` mirroring the group tree,
fast-forwarding clean checkouts and skipping dirty or diverged ones with a
report,
so that setup is one command and no local work is overwritten.

### A child repo's targets run from its parent dir (implemented)

I want the profile's `tree/` parent Makefiles linked onto the workspace parents,
delegating `make <repo>-<target>`,
so that running a repo's target needs no cd.

## As a workspace maintainer

Owns the profile's scripts and its `tree/`. Commits no generated output.

### Every subgroup dir carries a fresh index (implemented)

I want the index script to write `assets/data/repo-index.md` plus rendered
`AGENTS.md`/`CLAUDE.md` per subgroup dir, none of it checked into any repo,
so that agents read a current map that pollutes no repo history.

### The VS Code workspace file has one home (implemented)

I want repo additions and removals edited in the profile's `tree/`,
so that the host copy is always a link to the canonical file.

<!-- [<] 🤖🤖 -->
