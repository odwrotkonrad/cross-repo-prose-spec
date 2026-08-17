# Feature: Remote Source Ref Pinning

<!-- [>] 🤖🤖 -->

Any remote source pins to a git ref with an `@<tag|sha>` suffix, bound to
repo+path, placed before the `::<profile>` separator:
`@<repo>//<path>[@<ref>][::<profile>]`. Profile sources, renderTemplates sources
and `remoteFile` share the syntax. The `?ref=<ref>` query is a deprecated alias:
still parsed, never emitted.

A pinned ref is immutable: fetched once into its own checkout, reused offline
after that. An unpinned source tracks HEAD.

Scenario: a consumer pins a profile source and stops tracking upstream HEAD
  Status: todo
  Given a profile source `@<repo>//<path>/che.yml@<tag>::<profile>`
  When che resolves that source
  Then it checks out the repo at `<tag>`
  And a later upstream push to the default branch does not change what is loaded

Scenario: one ref syntax covers every remote source kind
  Status: todo
  Given a spec with a pinned profile source, a pinned renderTemplates source and a pinned `remoteFile` call
  When each is resolved
  Then all three accept the same `@<ref>` suffix

Scenario: existing pins keep working while the workspace migrates
  Status: todo
  Given a source pinned with the deprecated `?ref=<ref>` query
  When che resolves it
  Then it resolves the same ref as the `@<ref>` form

Scenario: an SCP-style git url is never mistaken for a ref
  Status: todo
  Given an unpinned source whose url carries a user prefix (`@git@<host>:<group>/<repo>.git`)
  When the source is parsed
  Then no ref is extracted
  And the url resolves as it did before ref support

Scenario: a profile name is never mistaken for a ref
  Status: todo
  Given a pinned source `@<repo>//<path>/che.yml@<tag>::<profile>`
  When the source is parsed
  Then the ref is `<tag>` and the profile is `<profile>`

Scenario: two pins of one repo coexist in a single run
  Status: todo
  Given two sources of the same repo pinned to different refs
  When both are resolved
  Then each resolves from its own checkout
  And neither overwrites the other's working tree

Scenario: a pinned run costs no network after its first fetch
  Status: todo
  Given a pinned source already fetched into the cache
  When che resolves it again
  Then it reuses the cached checkout without fetching

Scenario: an unresolvable pin fails loudly instead of loading the wrong content
  Status: todo
  Given a source pinned to a ref that does not exist upstream
  When che resolves it
  Then the run aborts naming the source and the ref
  And no stale cached checkout is substituted

Scenario: an unpinned source keeps its resilient update behavior
  Status: todo
  Given an unpinned remote source with a cached checkout
  When a fetch fails
  Then che warns and proceeds with the cached checkout

Scenario: an empty ref is a spec error, not an unpinned source
  Status: todo
  Given a source ending in `@` with no ref after it
  When the spec is loaded
  Then che reports the malformed source

<!-- [<] 🤖🤖 -->
