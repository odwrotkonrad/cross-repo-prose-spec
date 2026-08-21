# Feature: Prose Centralization

<!-- [>] 🤖🤖 -->

All workspace prose lives in semver-tagged prose repos, not in the consumers:
conventions and specs in `cross-repo/prose/spec`, purpose docs, README
sources, shared fragments and doc templates in `cross-repo/prose/assets` (the
split is in `split/assets-spec-misc.story.md`). Downstream repos assemble
their own docs, `che.yml` renderTemplates pulling artifacts at a pinned
version. Prose ships artifacts, never renders into another repo.

## As a prose author

Edits workspace prose in the prose repos only.

### Edit any workspace prose in one repo (implemented)

I want every convention, purpose doc, README source, spec and shared fragment
to live in prose alone,
so that no downstream copy drifts from what I wrote.

### Find a repo's prose by its repo path (implemented)

I want `repos/<repo-path>/` to mirror the GitLab group tree,
so that I find a repo's purpose doc, README source or specs without searching.

### Author shared prose once (implemented)

I want a fragment several repos consume to live under `shared/`,
so that I never duplicate or re-sync it per repo.

## As a downstream repo owner

Consumes prose at a pinned version, decides the repo's doc layout.

### Keep control of my own doc assembly (implemented)

I want my `che.yml` renderTemplates, pinned to a prose version, to decide what
gets assembled and where it lands,
so that prose supplies sources, not layout.

### Keep rendered doc assemblies out of version control (implemented)

I want AGENTS.md, CLAUDE.md and their intermediates gitignored and rendered on
demand,
so that prose is the only checked-in source of their content.

### Consume a multi-piece document as one ready artifact (todo)

I want prose to render the join itself,
so that I place one artifact instead of re-assembling pieces.

### Get the workspace repo index generated, never checked in (implemented)

I want the index generated into the workspace dir, outside any repo,
so that no repo carries a stale copy.

### Derive the index from prose's repos tree (todo)

I want the index read from `repos/<repo-path>/purpose.md` in prose, not from
a clone sweep,
so that local worktrees refresh it like any other generated output.

<!-- [<] 🤖🤖 -->
