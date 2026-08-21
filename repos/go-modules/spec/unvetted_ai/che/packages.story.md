# Feature: Che Packages

<!-- [>] 🤖🤖 -->

`che packages` installs packages declaratively from a packages file
(`$XDG_CONFIG_HOME/packages/packages.yml`): each canonical name lists managers in
preference order (brew, brew/cask, apt, npm, go, gem, binariesRemoteArchive,
script, pyenv, nvm, nix), first applicable on this host wins. Profiles declare
`include.installPackages`, the run installs them before `runScripts`. Four check
subcommands report presence, upgradability, shadowing, duplicates.

## As a catalog author

Writes the packages file. Declares what a package is and how each manager
spells it, never how installs run.

### A package named once, by its CLI name, resolving everywhere (tested)

I want a canonical name (the CLI program name where there is one) to install on
any supported host, bare installer items reusing it,
`installerVocabulary.packageName` overriding per installer, casks under the
`brew/cask` installer key, vscode extensions under `toolPackages.vscode` rather
than an installer key,
so that one entry serves every platform.

### Every supported installation method available, unknown ones rejected (tested)

I want brew, brew/cask, apt, npm, go, gem, binariesRemoteArchive, script, pyenv,
nvm and nix to work wherever `osInstallers` makes them eligible (every platform:
binariesRemoteArchive, script, npm, go, gem, pyenv, nvm, nix, linux-debian adds
apt, darwin adds brew and brew/cask), any other method a hard error naming the
valid set,
so that a typo in a method name never quietly installs nothing.

### Managers listed in preference order, first applicable winning (tested)

I want the first applicable item in entry order to install: brew/cask on macos
with brew present, apt on linux with apt-get, go and gem where their command
exists, npm even without the command when nothing else strictly applies,
binariesRemoteArchive when platformEligibility carries this os-arch. Unknown
manager, unknown package name: hard errors. A requested package with no
applicable method: hard error (`--missing-method-warn` downgrades it), a
dependency-pulled one: logged skip,
so that fallbacks are list order alone.

### A version pin converging the host, downgrades included (tested)

I want an entry- or item-level `version:` to reinstall on drift (npm
`name@<pin>`, apt `name=<pin>`, go `module@v<pin>`, gem `-v <pin>`, unpinnable
managers running their update path), a pin embedded in an item name a parse
error naming the version field, install and dry-run messages labeling the
package with its pin,
so that a pin is a stated version, not a floor.

### An absent version meaning rolling, a stated one checked (tested)

I want no `version:` to track the manager's current release with no drift check,
an entry-level version allowed only when every installer honors it, item-level
versions beating it, `latest` meaning no pin, an unenforceable version warning
and installing the current release (casks are rolling), the old `__rolling__`
sentinel a parse error,
so that rolling is omission, not a sentinel.

### An entry-level version guarding any package's installed version (tested)

I want an exact entry `version:` to override the item pin for the drift check,
matched against whole version tokens of the probe output, a
binariesRemoteArchive item using `{version}` to require a pin (entry, item or
requested, else hard error), a drifted manager-installed package to run the
manager's update path with check-upgradable warning, entries whose manager ships
one recent version unpinned by convention while the builtin pins every
version-distributing entry,
so that one field states the version the host must reach.

### A pinned brew item deriving its versioned formula (tested)

I want a pin to install `<name>@<pin>` with the suffix derived, never written,
a literal version suffix in `installerVocabulary.packageName` a parse error, an
unpinned item installing the bare formula,
so that formula names stay bare and pins stay in one field.

### An apt version string mapped once where it diverges (tested)

I want `installerVocabulary.versionMap: {"<binary-version>": "<package-version>"}`
to install `name=<package-version>` (downgrades allowed), the drift check
comparing dpkg's version and check-upgradable probing the binary version, the
map holding exactly one pair and the item naming exactly one deb via
`installerVocabulary.packageName`,
so that a decorated debian version never leaks into the entry's version.

### Apt repositories declared once as registries (tested)

I want third-party repos under `installerRegistries.apt` referenced by
scheme-less url (`fromRegistry: <host/path>[::<suites>[::<components>]]`, an
ambiguous reference a hard error naming the narrowing syntax), installing an
item to configure the registry (keyring plus deb822 file named by the registry
slug) even when the package is present so a pruned repo file heals,
`verificationKey` taking a url or absolute path, explicit `suites:` installing
with `-t <suites>` so exact-version dependencies resolve, an undeclared registry
or one missing url or verificationKey a hard error,
so that a repo is defined once and reused by every entry needing it.

### Brew taps declared once as registries (tested)

I want taps under `installerRegistries.brew` referenced as
`fromRegistry: cirruslabs/cli`, install tapping the repo then installing the
tap-qualified name, a tap-qualified `packageName` a parse error naming the
registries block, a reference to an absent tap a hard error,
so that tap knowledge sits in one place.

### A nix item installing from nixpkgs via nix profile (tested)

I want a `- nix` item eligible on linux and darwin, last in preference order,
the `nix` basePackages group bootstrapping nix via the Determinate Systems
installer (daemon on hosts, `--init none` in containers, `/nix/receipt.json`
marking it installed) with fallback to
`/nix/var/nix/profiles/default/bin/nix` or `~/.nix-profile/bin/nix`, flake
sources under `installerRegistries.nix` picked by `fromRegistry` (default
`nixpkgs`, undeclared a hard error), unpinned items installing
`nix profile install <url>/<ref>#<attr>` with install lines naming the registry
and `--update` running `nix profile upgrade`, presence and version read from
`nix profile list` with a `--version` fallback, and a packageName carrying `#`,
`@` or `=`, or `platformEligibility`, `extractBinaries`, `archScheme` on a nix
item, all parse errors,
so that nixpkgs is reachable without preempting a native manager.

### A nix pin expressed as a registry-repo revision (tested)

I want `versionMap: {"<binary-version>": "<revision>"}` (exactly one pair) to
install `<registry-url>/<revision>#<attr>`, the drift check comparing the
profile's store-path version, a drifted install running
`nix profile remove <attr>` then installing the pinned ref, a pinned version
with no revision in versionMap a hard error naming versionMap, every builtin nix
item pinned to its registry's channel head with one rev per registry,
so that a nix pin is reproducible, not a name lookup.

### Arch labels and installer eligibility standardized (tested)

I want `archLabelSchemes:` naming arch spelling sets and `osInstallers:` keyed
from bare os to distro- and arch-qualified, the most specific matching key
winning and only its installers applying (built-in rules as fallback), apt
eligible only under `linux-debian` (distro from /etc/os-release ID),
`platformEligibility` ids validated as `<os>-<arch>` against both blocks (an
unknown value a hard error naming both), keys extending each other by yaml
anchor with alias lists flattening, a file without the blocks inheriting the
builtin's, `installerVocabulary.archLabelScheme` required on every item using
`{arch}`, the old `{arch_x}`/`{arch_g}` tokens and per-item `archNames:` maps
parse errors,
so that arch spelling is declared once and eligibility is explicit per host.

### A binariesRemoteArchive entry downloading, verifying, landing (tested)

I want url and `installerVocabulary.extractBinaries` members to expand
`{version}` `{os}` `{arch}` (spelled per archLabelScheme), the download verified
against the platform's algorithm-prefixed checksum (unprefixed a parse error, a
bare platform name skipping verification with a warning, a mismatch aborting),
`.tar.*` extracting the listed members, `.zip` unzipping, bare assets installing
as-is, a pinned version absent from the probe output reinstalling, the probe
running `<canonical> --version` then `version` unless `versionCommand:` says
otherwise,
so that a release asset installs as declaratively as a managed package.

### A vendor installer expressed as a declarative script entry (tested)

I want a `- script:` item (optional `os:` gate) with `run:`, `path:` or `url:` to
run via POSIX `/bin/sh -e` when the canonical command is missing, `path:`
relative to the packages file, `url:` fetched with retrying curl and aborting on
failure or empty body, a present command skipping the script, optional
`version:` and `platformEligibility` pinning declaratively (exporting
CHE_PKG_VERSION, CHE_PKG_SHA256 as bare hex, CHE_PKG_NAME/OS/ARCH and
CHE_PKG_ARCH_<SET>), a `--version` output lacking the pin reinstalling and
check-upgradable warning, dry run announcing `install <pkg> via script` without
running,
so that a curl-to-shell installer becomes a pinned, checkable entry.

### Scripts shipping next to the file that references them (tested)

I want a relative script `path:` in a superseding or override packages file (an
install method's or `postInstall`'s) to resolve against that file's directory,
never a same-named builtin script,
so that a user's file is self-contained.

### A json schema of the packages file structure (implemented)

I want `make render-docs` to generate `assets/data/packages.schema.json` from
the Go source beside che.schema.json, packages files opening with a
`# yaml-language-server: $schema=` modeline pointing at it, the builtin carrying
that modeline against the published url,
so that editors validate and complete entries in place.

## As an operator

Installs packages on a host. Reads the log, runs the checks, does not write the
catalog.

### A profile installing its packages before its scripts (tested)

I want `include.installPackages: [names...]` to run install-packages after
render-templates and before run-scripts, `exclude.installPackages` dropping
names, composed profiles' lists concatenating and deduping,
`run --skip-ops install-packages` skipping the stage,
so that scripts always find the tools they call.

### An installed package left alone by default (tested)

I want an unpinned installed package untouched by install,
so that a rerun is cheap and non-destructive.

### A manager installed earlier in the run serving later packages (tested)

I want resolution in rounds, a package needing npm installing in a later round
of the run that installed npm,
so that nobody orders a bootstrap by hand.

### An npm package bootstrapping node on a bare host (tested)

I want the npm `basePackages` group installed first (`node`, pulling `nvm` via
requires, nvm's script pulling curl, git, tar, unzip), nested base groups
ensured once per run, npm resolved through the nvm default node's bin dir when
off PATH, `--only-methods npm` not filtering the bootstrap,
so that a bare host installs an npm package in one command.

### An install log separating requested packages from deps (implemented)

I want dependency lines labeled `<requirer> dependency <pkg>`, requested
packages bare, a reinstall line showing the installed version when known, an
unpinned apt install line reporting the installed version, an updated line
reporting the post-update version,
so that the log says why each package is installed.

### A bare host installing with no packages file (tested)

I want che to fall back to its builtin packages.yml when no file exists at the
default path and none is configured, an explicitly configured missing path
still a hard error,
so that a fresh host works before any configuration.

### Single entries overridden without forking the file (tested)

I want an override file (`--packages-override` or
`$XDG_CONFIG_HOME/che/packages-override.yml`) to replace same-name entries and
append new ones, `--packages-file` and `packages.file` relocating the base,
so that one changed package does not mean maintaining a whole catalog.

### Everything refreshed on demand (implemented)

I want `che packages install --update` to update unpinned installed packages via
their manager (brew upgrade, apt-get install --only-upgrade, npm update -g),
pinned ones still converging on the pin,
so that one command brings a host current without breaking pins.

### Only the gaps filled (tested)

I want `--if-missing` to skip any package whose canonical command is anywhere on
PATH, regardless of manager,
so that a host with hand-installed tools is not churned.

### Installs restricted to chosen methods (implemented)

I want `packages.onlyInstallationMethods` (user config, spec options, profile
options, `--only-methods` or `CHE_PACKAGES_ONLY_METHODS`) to consider only items
using a listed manager with no fallthrough, a package with none applicable
skipping with `no applicable installation method`, an unknown manager name
failing validation, the restriction lifted for `requires` dependencies so a
build's prerequisites still resolve by their own methods,
so that a profile pins one installation method without starving its deps.

### A dry run announcing installs without touching the host (tested)

I want each pending package announced as `install <pkg> via <mgr> (dry run)`
with no manager command run,
so that an install plan is reviewable.

### binariesRemoteArchive installs relocatable, warned when off PATH (tested)

I want `packages.binariesRemoteArchive.installDestinationCandidates` (user
config, spec options, profile options or env, scalar or list, `~/` and `$VARs`
expanding, default `~/.local/bin`) with `checkPresentOnPath` (default true) to
pick the first candidate on PATH, warn once per run listing them and use the
first when none is, `checkPresentOnPath: false` skipping the probe and always
using the first,
so that a binary never silently lands where the shell cannot reach it.

### Method selection steered by preference (tested)

I want `packages.preferredInstallationMethods` (user config, spec options,
profile options, `--preferred-methods` or `CHE_PACKAGES_PREFERRED_METHODS`) to
try listed managers first in order within each entry, unlisted ones following in
entry order so fallbacks survive, an inapplicable preferred manager falling
through, the cascade flag/env > profile > spec > user config, an unknown method
name a hard error naming the valid set,
so that a host prefers a manager without editing the catalog.

### A manager's index refreshed before its first install (tested)

I want apt, brew and brew/cask to run their repo-update command before the first
install of the run, at most once, re-armed when a new apt registry is
configured, live-registry managers (npm, gem, go) running none,
so that a fresh package is found without a stale-index failure.

### Downloads cached across runs (implemented)

I want `--download-cache-dir <dir>` (env `CHE_PACKAGES_DOWNLOAD_CACHE_DIR`) to
store assets at `<dir>/<sha256(url)>-<basename>` and reuse them without curl, a
checksum mismatch deleting the cached file before failing, an empty value
keeping the per-install temp-dir behavior,
so that repeated runs and CI jobs stop re-downloading the same archives.

### An install run ending by proving the commands exist (implemented)

I want check-present to run over the installed set after a real run and warn on
missing commands, no other check running automatically,
so that a green install means the tools are callable.

### Presence audited on demand (tested)

I want `che packages check-present [pkg...]` to report each canonical command's
PATH presence and fail on any missing one,
so that a host is verifiable in one command.

### Drift spotted with check-upgradable (tested)

I want `che packages check-upgradable` to warn on manager-reported outdated
packages (brew outdated, apt list --upgradable, npm outdated -g) and on
binariesRemoteArchive entries whose `--version` output lacks the yaml pin,
so that a stale host is visible without installing anything.

### PATH shadowing spotted with check-not-shadowed (tested)

I want a package whose manager-expected binary is not the first PATH hit to warn
`shadowed by <path>`,
so that the binary che manages is the one the shell runs.

### Duplicate installs spotted with check-single-present (tested)

I want a canonical command present in more than one PATH dir to warn
`multiple-present` listing every location,
so that competing installs are found before they diverge.

### A vscode extension declared outside the manager pipeline (tested)

I want `toolPackages.vscode` (extension id to version pin, null meaning rolling)
installed by `che packages install --kind=vscode <id>` via
`code --install-extension <id>[@pin]`, a `vscode` installer key inside
`packages:` a parse error pointing at `toolPackages.vscode`,
so that tool-scoped packages never masquerade as PATH packages.

<!-- [<] 🤖🤖 -->
