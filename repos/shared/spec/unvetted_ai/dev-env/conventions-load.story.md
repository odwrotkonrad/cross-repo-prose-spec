# Feature: Conventions load once, from the host

<!-- [>] 🤖🤖 -->

`cross-repo/prose/spec` is the contract's home: `conventions/` and every
`repos/<repo-path>/spec/`. Nothing under it renders into a consumer repo. The
conventions summary (`conventions/conventions.md`) renders once onto the host,
beside the other agent prose payloads: `configs` `llm/base` renders it to
`~/.config/ai-agents/docs/conventions.md` at `PROSE_SPEC_REF`, the host
`AGENTS.md.ontoHost.tpl` `@`-includes it into `~/.config/claude/CLAUDE.md` and
`~/.config/codex/AGENTS.md`, exactly as `system.md`, `code.md`, `comments.md`
and `prose.md` load. Behavior specs are read in the spec repo, never rendered
anywhere.

## As an agent

Reads one system prompt, then one repo's docs. Pays for every duplicated line.

### Read the conventions once per session (todo)

I want the conventions summary reaching me through the host
`CLAUDE.md`/`AGENTS.md` alone, no repo's `AGENTS.md` carrying a copy,
so that entering a repo costs its own prose, not the workspace contract again.

### Find behavior specs where they are authored (implemented)

I want a repo's specs read in `cross-repo/prose/spec` under
`repos/<repo-path>/spec/`, no repo carrying a rendered copy,
so that the spec I read is the spec I edit.

## As a downstream repo owner

Owns one repo's `che.yml` and its rendered docs.

### Render nothing from the spec repo (todo)

I want my `che.yml` free of any `cross-repo/prose/spec` renderTemplates source,
`PROSE_SPEC_REF` dropped from my `.env.tpl`, CI variables and
`.repo/cross-repo-interface.yml` upstreams,
so that a spec release never re-renders my repo.

### Keep `assets/data/` free of the conventions summary (todo)

I want `assets/data/conventions.md` gone from my tree, my gitignore and my
`AGENTS.md.ontoRepo.tpl`,
so that my rendered docs carry only what this repo is.

## As a host owner

Loads `configs` onto a machine and gets the agent prose with it.

### Get the conventions with the other agent prose (todo)

I want `configs` `llm/base` rendering `conventions/conventions.md` from
`cross-repo/prose/spec` at `PROSE_SPEC_REF` into
`~/.config/ai-agents/docs/conventions.md`, gitignored in the `configs`
checkout like every other payload there,
so that one host load carries the whole contract.

### Keep `configs` the only spec consumer (todo)

I want `configs` holding the sole `PROSE_SPEC_REF` render, `infra/iac` keeping
only the group variable that publishes the version,
so that a spec release fans out to one repo, not ten.

<!-- [<] 🤖🤖 -->
