# Feature: One che Binary

<!-- [>] 🤖🤖 -->

che ships five binaries today: `che`, plus `render-tpl`, `render-dirs-tree`,
`render-makefile-doc` and `render-repo-group-index`. They are not independent
tools. All four wrap the same render engine (`che/render/render`) through the
same `checkcmd.Tool` shell, and every one of them is installed, versioned and
released in lockstep with che.

The cost lands on everyone downstream. `che/.goreleaser.yaml` carries five
builds, five archives and a five-binary deb; `che/.goreleaser.darwin.yaml`
mirrors it. The sandbox Dockerfile extracts three names out of one tarball. A
host that has che but missed a render binary fails at a call site, not at
install time. A new render entrypoint means a new build, a new archive, a new
tarball member, and an edit in every consumer that unpacks one.

Folding them into `che render <sub>` leaves one artifact to build, ship, pin
and pull, and makes the render engine discoverable from `che --help` instead of
from four separate `--version` strings.

## The command surface

Scenario: an operator installs one artifact and has every render entrypoint
  Status: todo
  Given a host with the che binary and nothing else from this project
  When the operator invokes `che render tpl`, `che render dirs-tree`, `che render makefile-doc` or `che render repo-group-index`
  Then each runs the same engine the standalone binary ran
  And no separate render binary needs installing, pinning or pulling

Scenario: an agent discovers the render entrypoints without knowing their names in advance
  Status: todo
  When the operator runs `che --help`
  Then `render` appears among che's commands
  And `che render --help` lists all four entrypoints with their descriptions
  And the generated `docs/cli.md` and `assets/data/cli-usage.md` carry them

Scenario: flags and arguments survive the move unchanged
  Status: todo
  Given an invocation that worked against a standalone render binary
  When the same flags and arguments are passed to the matching `che render` subcommand
  Then the output is byte-identical
  And `-f`, `--check` and `--version` behave as they did
  And a template reading paths in frontmatter, `readBody` or `renderDirsTree` still resolves them against the cwd

Scenario: the check mode that guards generated docs keeps working
  Status: todo
  Given a lefthook or CI step that ran a render binary with `--check` to catch stale generated files
  When it runs the `che render` subcommand with `--check` instead
  Then a drifted file still fails the step with the same diff output
  And the exit codes are unchanged

## Release and distribution

Scenario: a release produces one binary per platform, not five
  Status: todo
  When a tag pipeline builds che
  Then goreleaser produces a single `che` binary per platform in both the linux and darwin configs
  And the release tarball contains that binary alone
  And the deb installs that binary alone
  And no `render-*` archive is published

Scenario: consumers stop unpacking binaries that no longer exist
  Status: todo
  Given the sandbox image builds by extracting named members from the che tarball
  When it extracts after the collapse
  Then it names only `che`
  And no build breaks over a missing `render-tpl` or `render-repo-group-index` member

Scenario: hosts keep working while the rollout is in flight
  Status: todo
  Given consumers across configs, control, infra/sandbox and infra/oci-images call the standalone binaries
  When the subcommands ship
  Then the standalone binaries remain published until every consumer has migrated
  And they are removed from the release only after that
  And no host is left with a call site that resolves to nothing

## Callers

Scenario: secret rendering in shell hooks goes through che
  Status: todo
  Given the glab auth hook and the sandbox session bootstrap pipe a `{{ secret ... }}` template into a renderer
  When they run after migration
  Then they invoke `che render tpl -f /dev/stdin`
  And the resolved secret reaches the caller exactly as before
  And a renderer failure is still swallowed where it was swallowed before

Scenario: the workspace index generator depends on one command being present
  Status: todo
  Given `control/workspace/scripts/20-index.zsh` guards on a renderer being on PATH
  When it runs after migration
  Then it probes for `che`, not for `render-repo-group-index`
  And it generates the repo index and README body through `che render`
  And when che is absent it still skips with a clear message rather than failing

<!-- [<] 🤖🤖 -->
