# Feature: One che Binary

<!-- [>] 🤖🤖 -->

che ships one binary. `render-tpl`, `render-dirs-tree`, `render-makefile-doc` and
`render-repo-group-index` were once standalone, but they were never independent
tools: each wraps the same render engine (`che/render/render`) through the same
`checkcmd.Tool` shell, installed, versioned and released in lockstep with che.

Five builds, five archives and a five-binary deb per platform cost downstream
real work. A host with che but a missing render binary failed at a call site, not
at install time. Every new render entrypoint meant a new build, a new archive, a
new tarball member, and an edit in every consumer that unpacked one.

They now fold into `che render <sub>`: one artifact to build, ship, pin and pull,
with the render engine discoverable from `che --help` instead of four separate
`--version` strings.

## As an operator

Installs and invokes che on a host. Wants a working entrypoint, not a
distribution to assemble.

### One artifact carrying every render entrypoint (implemented)

I want `che render tpl`, `che render dirs-tree`, `che render makefile-doc` and
`che render repo-group-index` to run the same engine the standalone binaries
ran, with no separate render binary to install, pin or pull,
so that a host with che can render.

### Flags and arguments surviving the move (implemented)

I want an invocation that worked against a standalone binary to produce
byte-identical output under the matching subcommand, `-f` and `--check`
behaving as before and templates reading paths in frontmatter, `readBody` or
`renderDirsTree` still resolving against the cwd,
so that migrating is a command-name change and nothing else.

### The version flag answered under each render subcommand (todo)

I want `che render <sub> --version` to print the version as the standalone
binary did instead of failing on an invalid argument,
so that a version probe in a script survives the move.

### The check mode guarding generated docs still working (implemented)

I want a lefthook or CI step to swap in the `che render` subcommand with
`--check` and still fail on a drifted file with the same diff output and exit
codes,
so that the staleness guard survives the collapse untouched.

## As an agent

Reads che's help and generated docs to find a command. Cannot guess binary
names.

### Render entrypoints discoverable without knowing their names (implemented)

I want `render` among che's commands in `che --help`, `che render --help`
listing all four entrypoints with descriptions, and the generated `docs/cli.md`
and `assets/data/cli-usage.md` carrying them,
so that the surface is discoverable from the binary itself.

## As a release maintainer

Owns the build, the tags and the published artifacts. Does not own the
consumers.

### One binary per platform, not five (implemented)

I want goreleaser to produce a single `che` binary per platform in both the
linux and darwin configs, the tarball and deb containing that binary alone and
no `render-*` archive published,
so that a release is one artifact to verify.

### No host left with a call site resolving to nothing (implemented)

I want the standalone binaries kept published until every consumer across
configs, control, infra/sandbox and infra/oci-images had migrated, dropped only
then, with no consumer still invoking a `render-*` binary,
so that the collapse never broke a running host.

### Consumers no longer unpacking binaries that do not exist (implemented)

I want the sandbox image to extract only `che` from the tarball, no build
breaking over a missing `render-tpl` or `render-repo-group-index` member,
so that an image build does not encode the old artifact list.

## As a script author

Maintains the shell hooks and bootstrap scripts calling the renderer. Owns call
sites, not the binary.

### Secret rendering in shell hooks going through che (implemented)

I want the glab auth hook and the sandbox session bootstrap to pipe their
`{{ secret ... }}` template into `che render tpl -f /dev/stdin`, the resolved
secret reaching the caller exactly as before and a renderer failure still
swallowed where it was swallowed before,
so that the hooks behave identically after the move.

### The workspace index generator depending on one command (implemented)

I want `control/workspace/scripts/20-index.zsh` to probe for `che` rather than
`render-repo-group-index`, generate the repo index and README body through
`che render`, and still skip with a clear message when che is absent,
so that one probe covers every renderer it uses.

<!-- [<] 🤖🤖 -->
