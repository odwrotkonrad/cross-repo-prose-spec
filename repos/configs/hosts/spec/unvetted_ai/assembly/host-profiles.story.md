# Feature: Host profiles assembled from pinned tool repos

<!-- [>] 🤖🤖 -->

`hosts` owns no tool config. It names the hosts (`desktop/macos`, `cli/macos`,
`virt/linux`) and composes each from profiles `configs/tools` and
`configs/ai-tools` publish, at pinned releases.

## As a host owner

Runs `make sync` on a machine, expects the same result on every machine of
that kind.

### A host profile is a list of pinned includes (todo)

I want every include in `che.yml` a remote profile source with
`?ref=${{ env.CONFIGS_TOOLS_REF }}` or `?ref=${{ env.CONFIGS_AI_TOOLS_REF }}`,
no local `root/` tree, no local scripts beyond CI,
so that what lands on a host is exactly a released tools and ai-tools pair.

### The pins come from the group (todo)

I want `.env.tpl` seeding both refs from their `GRP_KO_VAR_*` variables, CI
remapping them once in `variables:`,
so that a release bump is one line in iac and the regen MR automation opens.

### One sync, all of it (todo)

I want `make sync` rendering repo docs, loading every eligible profile,
refreshing the workspace index and hooks, as `configs` did,
so that the split changes nothing in the daily command.

### A dry run proves a host before it applies (todo)

I want MR pipelines dry-running `virt/linux` on both arches and the macOS
profiles when darwin CI is on, `apply-linux` manual,
so that a pin bump is verified against a real host before merge.

<!-- [<] 🤖🤖 -->
