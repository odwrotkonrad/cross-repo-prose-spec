# Feature: Build-From-Source Installation Method

<!-- [>] 🤖🤖 -->

`buildFromSource` downloads a package's source tarball and runs autotools in it:
`./configure --prefix=<prefix>`, `make -j<cpus>`, `make install`. The prefix is
the parent of the binaries install destination (`~/.local/bin` -> `~/.local`),
so the default flow stays in user space, no sudo.

## As a developer

Installs packages on a machine they own. Wants the tool, not a build system to
learn.

### A package installed from its source tarball (tested)

I want a `buildFromSource` item with a `url` (`{version}` token allowed) and a
pinned version to download and extract the tarball, find its single top-level
source dir, run `./configure --prefix=<prefix>` with any `configureArgs`, then
`make -j<cpus>` and `make install`, removing the temp dir after,
so that a package with no manager still installs declaratively.

### A build that stays in user space (tested)

I want the prefix to be the parent of the binaries install destination
(default `~/.local/bin` -> `~/.local`),
so that the default flow needs no root.

### A system prefix escalating only the install step (tested)

I want a prefix outside `$HOME` (`/usr/local/bin` -> `/usr/local`) to run only
`make install` under sudo on linux as non-root, configure and make staying
unprivileged,
so that root touches the smallest possible step.

### A matching installed version skipping the build (tested)

I want the install skipped when the command is present and its version output
carries the pin, a drift rebuilding, dry run announcing
`install <pkg> <version> via buildFromSource`,
so that a rerun costs no compile.

### Build prerequisites ensured automatically (implemented)

I want the `buildFromSource` base-packages group (gcc, make) ensured before the
build,
so that a bare host builds without a manual toolchain step.

### Ruby available where no package manager serves it (implemented)

I want ruby 3.4.10 built from the checksum-verified ruby-lang.org tarball,
requiring libssl-dev, libyaml-dev and zlib1g-dev (apt-only, skipped elsewhere),
ruby-lsp requiring ruby rather than ruby-dev since a source-built ruby ships
its own headers,
so that ruby tooling works on a host with no ruby package.

## As a catalog author

Writes package entries. Declares intent, does not implement drivers.

### One checksum guarding the platform-independent tarball (implemented)

I want `checksum: sha256:<hex>` enforced against the download, a mismatch
aborting, an absent checksum installing with an `unverified` warning,
per-platform checksums rejected at parse time since a source tarball is one
artifact,
so that the declaration cannot promise what the method does not give.

### A version pinned where the checksum that describes it lives (tested)

I want `installPackages` to accept `checksum: sha256:<hex>` beside `versions`
on a package ref, overriding the catalog item's checksum when both are set and
verifying the tarball the pinned version downloads,
so that the catalog carries the build recipe while the consumer choosing the
version vouches for the artifact.

### Platform eligibility gating hosts, absence meaning everywhere (tested)

I want `platformEligibility` to restrict the method to the listed `<os>-<arch>`
platforms, an empty or absent list applying wherever `osInstallers` carries
`buildFromSource`,
so that a source build is scoped without listing every host.

<!-- [<] 🤖🤖 -->
