# Feature: Prose split by audience

<!-- [>] 🤖🤖 -->

## As a prose author

Writes conventions, specs, purpose docs, templates and shared scripts.

### Specs and conventions live in `spec` (implemented)

I want `conventions/` and every `repos/<repo>/spec/` in
`cross-repo/prose/spec`,
so that the contract repos obey is versioned apart from the prose rendered
into them.

### Rendered prose lives in `assets` (implemented)

I want purpose docs, templates, ai payloads and the license in
`cross-repo/prose/assets`, inheriting the prose project and its tags,
so that consumers keep their history and their pin stream.

### Shared scripts live in `misc` (implemented)

I want `shared/ci/*.zsh` and future CI templates in `cross-repo/misc`,
so that scripts release on their own cadence, apart from prose.

### `repos/<repo-path>` mirrors the group tree (implemented)

I want every per-repo dir renamed with its project,
so that the path under `repos/` always equals the project path.

<!-- [<] 🤖🤖 -->
