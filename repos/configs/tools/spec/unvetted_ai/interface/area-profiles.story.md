# Feature: Tool profiles published per area

<!-- [>] 🤖🤖 -->

`tools` is what `configs` was, minus the AI toolchain and minus the host
composition. Its interface is the set of per-area aggregate profiles other
repos include at a tag.

## As a consumer spec author

Includes tool profiles from `hosts` or the sandbox image, pins a release.

### Every area exposes base, host and virt aggregates (todo)

I want each `profiles/<area>/che.yml` publishing `<area>/base/macos`,
`<area>/host/macos`, `<area>/virt/linux`, the root `che.yml` publishing
`base/packages` and `base`,
so that a consumer composes a host from area names, never from leaf paths.

### No AI inside (todo)

I want `profiles/llm/` gone, claude, codex and ccstatusline out of
`base/packages`, the prose AI payload renders out of `.repo/che.yml`,
so that an AI change never releases the tool profiles.

### Nothing binds to a consumer checkout (todo)

I want `base` free of `$PWD`-anchored dirs and scripts,
so that a remote include from any repo loads without a `configs` checkout
layout.

## As the repo owner

Releases `tools` on every merge, proves it loads.

### A smoke profile proves the release (todo)

I want a `ci/virt-linux` profile including every `<area>/virt/linux`,
dry-run on MRs, applied manually,
so that CI proves the profiles this repo publishes without a host repo.

<!-- [<] 🤖🤖 -->
