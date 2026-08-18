# Feature: Prose Centralization

<!-- [>] 🤖🤖 -->

One semver-tagged `prose` repo holds all workspace prose: conventions, purpose
docs, README sources, specs, shared fragments, canonical doc templates.
Downstream repos own assembly, their `che.yml` renderTemplates consuming prose
artifacts at a pinned version. Prose ships artifacts, never renders into other
repos.

## As a prose author

Writes and edits workspace prose in the prose repo, never in a consumer.

### Edit any workspace prose in one repo (implemented)

I want every convention, purpose doc, README source, spec and shared fragment
to live only in prose,
so that no downstream copy can drift from what I wrote.

### Find a repo's prose by its repo path (implemented)

I want `repos/<repo-path>/` to mirror the GitLab group tree,
so that I locate any repo's purpose doc, README source or specs without
searching.

### Author prose shared by several repos in exactly one place (implemented)

I want a fragment more than one repo consumes to live under `shared/`,
so that I never duplicate or re-sync it per repo.

## As a downstream repo owner

Owns a repo consuming prose at a pinned version, decides its own doc layout.

### Keep control of my own doc assembly (implemented)

I want my `che.yml` renderTemplates, pinned to a prose version, to decide what
is assembled and where it lands,
so that prose supplies sources without dictating my layout.

### Keep rendered doc assemblies out of my version control (implemented)

I want AGENTS.md, CLAUDE.md and their generated intermediates gitignored and
rendered on demand,
so that the only checked-in source of their content is prose.

### Consume a multi-piece document as one ready artifact (todo)

I want prose to render the join itself,
so that I place the artifact instead of re-assembling its pieces.

### Get the workspace repo index generated, never checked in (todo)

I want the index derived from prose's repos tree without a clone sweep,
so that no repo carries a stale copy and local worktrees refresh it like any
other generated output.

<!-- [<] 🤖🤖 -->
