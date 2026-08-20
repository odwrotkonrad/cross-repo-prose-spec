# Feature: Shared material lives under one cross-repo group

<!-- [>] 🤖🤖 -->

Product repos sit at the root of `konradodwrot`. Everything they share
(automation, prose, CI scripts, infra) sits beside them, indistinguishable.
A `cross-repo` group names the shared layer, `infra` folds into it, the AI
sandbox rises to the root as `ai-sandbox`.

## As the group owner

Declares the GitLab tree in Terraform, applies it through CI, never clicks.

### A repo moves with its identity (implemented)

I want a project declared under a new group, or under a new name, to be
transferred, keeping its id, history, tags, MRs, issues and CI variables,
so that a reorganisation never recreates a repo.

### An empty group disappears with the move (implemented)

I want a group left empty by transfers removed in the same change,
so that the tree holds no shells.

### A GitHub mirror is named after the full path (implemented)

I want a project under a subgroup mirrored to `<group>-<subgroup>-<leaf>`
on GitHub, a root project to `<leaf>`, and a rename to rename the GitHub
repo in place,
so that mirror names never collide and no orphan mirror remains.

### A token lookup survives any depth (implemented)

I want every per-project token and variable bound through the project's
full path, whatever level it sits at,
so that moving a tagging or publishing project never breaks its identity.

### Each producer publishes its own pin (implemented)

I want one group variable per released producer (`prose/assets`,
`prose/spec`, `misc`, che-packages, ci images),
so that a consumer pins each upstream independently.

<!-- [<] 🤖🤖 -->
