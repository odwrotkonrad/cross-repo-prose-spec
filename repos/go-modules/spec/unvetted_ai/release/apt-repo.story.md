# Feature: Signed Apt Repo on Pages

<!-- [>] 🤖🤖 -->

`publish-apt`: every Pages deploy rebuilds the signed apt repo tree at
`https://konradodwrot.gitlab.io/go-modules/apt` from every che `.deb` in the
generic package registry.

## As a release consumer

Installs che with apt on debian. Builds nothing, reads no pipeline.

### che installs with plain apt (implemented)

I want `che_X.Y.Z_linux_{amd64,arm64}.deb` in the registry and served from
`apt/dists/stable` component `main`,
so that `apt update && apt install che` puts che and the render CLIs in
`/usr/bin`.

### An exact version installs, apt-native (implemented)

I want the rebuilt pool to keep every version's deb, none removed by later
releases,
so that `apt install che=X.Y.Z` works with no `che@X.Y.Z` package clones.

### The repo signature verifies against a published key (implemented)

I want the `Release` file GPG-signed with `$APT_GPG_PRIVATE_KEY` and the armored
public key served at `apt/gpg.key`,
so that `signed-by` has a key to point at.

## As a pipeline maintainer

Owns the Pages deploy and the apt build. Owns no package content.

### A docs-only deploy never wipes the apt repo (implemented)

I want `apt-build-che` to regenerate the full tree from the registry before
`pages-publish` composes docs and `public-apt`,
so that a default-branch push touching `che/` cannot drop the repo.

### The first deploy works before any deb exists (implemented)

I want `publish-apt` to publish only `apt/gpg.key` and exit 0 on an empty
registry,
so that bootstrapping needs no release first.

<!-- [<] 🤖🤖 -->
