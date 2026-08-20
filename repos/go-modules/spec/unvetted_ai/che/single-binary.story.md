# Feature: One che Binary

<!-- [>] 🤖🤖 -->

che ships one binary. `render-tpl`, `render-dirs-tree`, `render-makefile-doc` and
`render-repo-group-index` were standalone but never independent: each wrapped
the same engine (`che/render/render`) through the same `checkcmd.Tool` shell,
versioned and released in lockstep with che.

Five builds, five archives and a five-binary deb per platform cost downstream
real work. A host with che but no render binary failed at the call site, not at
install. Each new entrypoint meant a new build, archive, tarball member and an
edit in every consumer unpacking one.

They now live under `che render <sub>`: one artifact to build, ship, pin and
pull, discoverable from `che --help`.

## As an operator

Installs and invokes che on a host. Wants a working entrypoint, not a
distribution to assemble.

### One artifact carrying every render entrypoint (implemented)

I want `che render tpl`, `che render dirs-tree`, `che render makefile-doc` and
`che render repo-group-index` to run the engine the standalone binaries ran, no
separate binary to install, pin or pull,
so that a host with che can render.

### Flags and arguments surviving the move (implemented)

I want a working standalone invocation to give byte-identical output under the
matching subcommand, `-f` and `--check` unchanged, paths in frontmatter,
`readBody` or `renderDirsTree` still resolving against the cwd,
so that migrating is a command-name change and nothing else.

### The version flag answered under each render subcommand (todo)

I want `che render <sub> --version` to print the version as the standalone
binary did, not fail on an invalid argument,
so that a version probe in a script survives the move.

### The check mode guarding generated docs still working (implemented)

I want a lefthook or CI step to swap in `che render <sub> --check` and still
fail on a drifted file with the same diff output and exit codes,
so that the staleness guard survives untouched.

## As an agent

Finds commands through che's help and generated docs. Cannot guess binary
names.

### Render entrypoints discoverable without knowing their names (implemented)

I want `render` listed in `che --help`, `che render --help` listing all four
entrypoints with descriptions, and the generated `docs/cli.md` and
`assets/data/cli-usage.md` carrying them,
so that the surface is discoverable from the binary itself.

## As a release maintainer

Owns the build, tags and published artifacts. Does not own the consumers.

### One binary per platform, not five (implemented)

I want goreleaser to produce a single `che` binary per platform in both the
linux and darwin configs, tarball and deb containing that binary alone, no
`render-*` archive published,
so that a release is one artifact to verify.

### No host left with a call site resolving to nothing (implemented)

I want the standalone binaries kept published until every consumer (configs,
control, infra/sandbox, infra/oci-images) had migrated, dropped only then,
so that the collapse never broke a running host.

### Consumers no longer unpacking binaries that do not exist (implemented)

I want the sandbox image to extract only `che` from the tarball, no build
breaking on a missing `render-tpl` or `render-repo-group-index` member,
so that an image build does not encode the old artifact list.

## As a script author

Maintains the shell hooks and bootstrap scripts calling the renderer. Owns call
sites, not the binary.

### Secret rendering in shell hooks going through che (implemented)

I want the glab auth hook and the sandbox session bootstrap to pipe their
`{{ secret ... }}` template into `che render tpl -f /dev/stdin`, the secret
reaching the caller as before, a renderer failure swallowed where it was
swallowed before,
so that the hooks behave identically after the move.

### The workspace index generator depending on one command (implemented)

I want `control/workspace/scripts/20-index.zsh` to probe for `che` instead of
`render-repo-group-index`, generate the repo index and README body through
`che render`, and still skip with a clear message when che is absent,
so that one probe covers every renderer it uses.

<!-- [<] 🤖🤖 -->
