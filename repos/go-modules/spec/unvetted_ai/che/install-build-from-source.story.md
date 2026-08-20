# Feature: Build-From-Source Installation Method

<!-- [>] 🤖🤖 -->

`buildFromSource` downloads a package's source tarball and runs autotools in it:
`./configure --prefix=<prefix>`, `make -j<cpus>`, `make install`. The prefix
derives from the binaries install destination (`~/.local/bin` -> `~/.local`), so
the default flow stays in user space, no sudo.

## As a developer

Installs packages on a machine they own. Wants a tool present, not a build
system to learn.

### A package installed from its source tarball (tested)

I want a `buildFromSource` item with a `url` (a `{version}` token allowed) and a
pinned version to download and extract the tarball, locate its single top-level
source dir, run `./configure --prefix=<prefix>` with any `configureArgs`, then
`make -j<cpus>` and `make install`, removing the temp dir afterwards,
so that a package with no manager still installs declaratively.

### A build that stays in user space (tested)

I want the prefix derived as the parent of the binaries install destination
(default `~/.local/bin` -> `~/.local`),
so that the default flow needs no root.

### A system prefix escalating only the install step (tested)

I want a prefix outside `$HOME` (`/usr/local/bin` -> `/usr/local`) to run only
`make install` under sudo on linux as non-root, configure and make staying
unprivileged,
so that root touches the smallest possible step.

### A matching installed version skipping the build (tested)

I want an install skipped when the command is present and its version output
carries the pin, a drift rebuilding, dry run announcing
`install <pkg> <version> via buildFromSource`,
so that a rerun does not cost a compile.

### Build prerequisites ensured automatically (implemented)

I want the `buildFromSource` base-packages group (gcc, make) ensured before the
build,
so that a bare host builds without a manual toolchain step.

### Ruby available where no package manager serves it (implemented)

I want ruby 3.4.10 built from the checksum-verified ruby-lang.org tarball with
libssl-dev, libyaml-dev and zlib1g-dev required (apt-only, skipped where
inapplicable), ruby-lsp requiring ruby rather than ruby-dev because a
source-built ruby ships its own headers,
so that ruby tooling works on a host with no ruby package.

## As a catalog author

Writes package entries. Declares intent, does not implement drivers.

### One checksum guarding the platform-independent tarball (implemented)

I want `checksum: sha256:<hex>` enforced against the download, a mismatch
aborting, an absent checksum installing with an `unverified` warning, and
per-platform checksums rejected at parse time because a source tarball is one
artifact,
so that the declaration cannot express a guarantee the method does not give.

### A version pinned where the checksum that describes it lives (tested)

I want `installPackages` to accept `checksum: sha256:<hex>` beside `versions` on
a package ref, that checksum overriding the catalog item's when both are set and
verifying the tarball the pinned version downloads,
so that a catalog entry can carry the build recipe while the consumer that
chooses the version also vouches for the artifact.

### Platform eligibility gating hosts, absence meaning everywhere (tested)

I want `platformEligibility` names to restrict the method to those `<os>-<arch>`
platforms, an empty or absent list applying wherever `osInstallers` carries
`buildFromSource`,
so that a source build is scoped without listing every host.

<!-- [<] 🤖🤖 -->
