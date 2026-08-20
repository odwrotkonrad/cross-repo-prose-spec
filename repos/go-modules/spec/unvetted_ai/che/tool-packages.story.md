# Feature: Tool-Scoped Packages (toolPackages)

<!-- [>] 🤖🤖 -->

Packages living inside a host tool, not on PATH (vscode extensions, gcloud
components, pip/npm libraries later), go in a top-level `toolPackages:` section
of packages.yml, keyed by tool, each entry a name mapping to a pin (null/empty:
rolling). Profiles select them via `include.installToolPackages`, the CLI via
`che packages install --kind=<tool>`.

A tool whose packages carry no version of their own says so, and che refuses
pins for it instead of dropping them.

## As a catalog author

Declares tool-scoped packages in packages.yml. Writes yaml, not tool drivers.

### Tool-scoped packages declared per host tool (tested)

I want `toolPackages.<tool>` to take `name: pin` and bare `name:` entries (bare
or null: rolling, scalar: pinned), an unknown tool key a parse error listing the
known tools, overrides merging and `che packages config --delta` diffing per
tool entry,
so that a tool's packages are declared where PATH packages are.

### An unversionable tool rejecting pins instead of ignoring them (implemented)

I want a pin on a `toolPackages.gcloud` package, or a profile ref pinning one
via `{name, version}`, to error naming the tool and the package, the generated
schema admitting only null values for such a tool, bare entries decoding as
rolling,
so that a pin that cannot be honored is refused, not dropped.

## As a config author

Selects tool packages in profiles. Owns which land on a host, not how.

### Tool packages installed next to regular packages (implemented)

I want `installToolPackages: {vscode: [name, {name, version}]}` installed by the
install-packages op after the profile's regular packages, included profiles
composing per tool with later refs re-pinning by name,
`exclude.installToolPackages` dropping names per tool, presence checked after a
real run via the tool's own listing,
so that one profile describes a host completely.

### GKE components declared, not hand-installed (tested)

I want `installToolPackages: {gcloud: [gke-gcloud-auth-plugin]}` with
`basePackages.gcloud` naming `gcloud` to install the SDK first through the
regular pipeline, then the component via
`gcloud components install --quiet <id>`, presence read from
`gcloud components list` (any state but `Not Installed` counts), a second run
reporting it installed and running nothing,
so that a cluster prerequisite is part of the declared host.

## As an operator

Runs the installs. Reads what happens when a tool is missing or crippled.

### Tool packages installed directly via --kind (implemented)

I want `che packages install --kind=vscode <name...>` to resolve each name in
`toolPackages.vscode` (unknown name: hard error naming the file), skip a
present package with a matching pin, reinstall a drifted one, `--update`
refreshing unpinned ones, dry-run printing would-be installs without running
the tool, and `che packages check-present --kind=vscode` erroring on missing
entries, defaulting to the profiles' selection else the whole section,
so that one tool's packages are managed without a full run.

### The tool's carrier installed first, an absent tool warned (tested)

I want `basePackages.<tool>` (vscode: code) installed first through the regular
pipeline, and the tool's packages skipped with a warning when the tool command
is still absent,
so that a headless host does not fail a run over an editor it lacks.

### An SDK without a component manager warning instead of failing (todo)

I want gcloud tool packages under an SDK whose package manager disables
component management to skip with a warning, `--update` refreshing through
`gcloud components update`, the whole SDK the only unit gcloud versions,
so that a distro-packaged SDK does not break an otherwise valid run.

<!-- [<] 🤖🤖 -->
