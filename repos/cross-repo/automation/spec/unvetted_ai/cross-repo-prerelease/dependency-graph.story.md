# Feature: Aggregated Repo Dependency Graph

<!-- [>] 🤖🤖 -->

One generated graph names every repo, the artifacts it produces, and the edges
between them. Prerelease preference and prose propagation resolve against it. A
vertex is `repo/artifact`.

Nothing here is hand-maintained. Each repo declares its own surface in
`.repo/cross-repo-interface.yml`: `upstream:` lists consumed vertices as
`<repo>/<artifact>` strings (repo-level consumption), `edges:` maps an upstream
vertex to this repo's artifacts it lands in (`go-modules/lib: [che]`), and
`downstream:` lists produced artifacts as `name:` + `type:`. Types so far:
`binary | go-module | oci-image | che-profile | ai-prose | lockfile | pdf | dataset`.

Aggregation merges all declarations over bootstrap seeds
(`deps/seed-interfaces.yml`, shrinking as repos declare) and renders the
canonical `deps/deps-graph.yml`: `repositories:` for vertices, `edges:` mapping
an upstream vertex to its downstream vertices. A bare `<repo>` means the repo's
pipeline or worktree consumes it, `<repo>/<artifact>` means it lands in an
artifact.

## As a downstream repo owner

Declares what the repo consumes and produces. Maintains no cross-repo list.

### Upstreams come from the graph, not per-repo config (todo)

I want an MR pipeline to read its upstreams from the generated graph,
so that resolving dependencies needs nothing configured locally.

### Prerelease resolution is per artifact (todo)

I want the exact artifact vertex depended on to be resolved,
so that a prerelease of `go-modules/che` leaves `go-modules/lib` untouched.

## As a workspace maintainer

Reads and audits the graph. Hand-edits none of it.

### The whole dependency structure answers from one file (implemented)

I want vertices in `repositories:` and edges in `edges:`,
so that what depends on what is one file's answer.

### Declarations and generated graph cannot drift (implemented)

I want CI to re-aggregate and fail on any difference from the committed graph,
so that a stale generated file is impossible.

### A dangling declaration fails loudly (implemented)

I want aggregation to fail naming the consumer and the missing artifact,
so that an upstream nobody produces is caught at generation, not at use.

<!-- [<] 🤖🤖 -->
