# Feature: Cross-Repo Interface Declarations

<!-- [>] 🤖🤖 -->

Each repo declares its own cross-repo surface in
`.repo/cross-repo-interface.yml`. `upstream:` lists the `<repo>/<artifact>`
vertices it consumes repo-level, `edges:` maps an upstream vertex to this repo's
artifacts it lands in, `downstream:` lists the artifacts it produces (`name` +
`type`). Control aggregates every declaration into one generated dependency
graph. No central file is hand-maintained.

## As a repo owner

Maintains one repo's cross-repo surface, sees no other repo's declarations.

### Declare my repo's dependencies where they live (implemented)

I want my interface changes confined to my own
`.repo/cross-repo-interface.yml`,
so that I never edit a central file to describe my repo.

### Drop my bootstrap seed the moment I declare (implemented)

I want adding my own interface file to leave aggregation output unchanged,
so that removing my seed entry is safe.

## As a workspace maintainer

Reasons about the whole dependency graph, owns no single repo's interface.

### Derive the whole graph from per-repo declarations (implemented)

I want control to merge every declaration over the bootstrap seeds into one
generated, committed `deps/deps-graph.yml`,
so that the graph stays readable without ever being hand-edited.

### Catch a dangling consumption instead of silent drift (implemented)

I want aggregation to fail naming the consumer and the missing artifact,
so that an `upstream:` entry no repo produces cannot pass unnoticed.

<!-- [<] 🤖🤖 -->
