# Feature: Tool-Scoped Packages (toolPackages)

<!-- [>] 🤖🤖 -->

Packages living inside a host tool rather than on PATH (vscode extensions,
gcloud components, pip/npm libraries later) are declared in a top-level
`toolPackages:` section of packages.yml, keyed by tool, each entry a package name
mapping to a version pin (null/empty: rolling). Profiles select them via
`include.installToolPackages`, the CLI via `che packages install --kind=<tool>`.

Tools differ in what they can version. A tool whose packages carry no version of
their own declares so, and che refuses pins for it rather than silently dropping
them.

Scenario: a packages file declares tool-scoped packages per host tool
  Status: tested
  When packages.yml carries `toolPackages.<tool>` with `name: pin` and bare `name:` entries
  Then a bare/null value means rolling, a scalar pins the version
  And an unknown tool key is a parse error listing the known tools
  And overrides merge per tool entry and `che packages config --delta` diffs per tool entry

Scenario: a profile installs tool packages next to regular packages
  Status: tested
  When a profile includes `installToolPackages: {vscode: [name, {name, version}]}`
  Then the install-packages op installs them after the profile's regular packages
  And included profiles compose per tool, later refs re-pin by name, `exclude.installToolPackages` drops names per tool
  And after a real run their presence is checked via the tool's own listing

Scenario: a user installs tool packages directly via --kind
  Status: tested
  When I run `che packages install --kind=vscode <name...>`
  Then each name resolves in `toolPackages.vscode` (an unknown name is a hard error naming the file)
  And a present package with a matching pin skips, a drifted pin reinstalls, `--update` refreshes unpinned ones
  And dry-run emits the would-be installs without running the tool
  And `che packages check-present --kind=vscode` errors on missing entries, defaulting to the profiles' selection, else the whole section

Scenario: the tool's own base packages install first, an absent tool skips with a warning
  Status: tested
  When a tool package installs and `basePackages.<tool>` names the tool's carrier package (vscode: code)
  Then the carrier installs first through the regular pipeline
  And if the tool command is still absent the tool's packages skip with a warning instead of erroring

Scenario: a GKE user gets gcloud components declared, not hand-installed
  Status: tested
  Given `basePackages.gcloud` names `gcloud`, so the SDK installs through the regular pipeline first
  When a profile includes `installToolPackages: {gcloud: [gke-gcloud-auth-plugin]}`
  Then the component installs via `gcloud components install --quiet <id>`
  And presence comes from `gcloud components list`, an id whose state is not `Not Installed` counting as installed
  And a second run reports it already installed and runs nothing

Scenario: an unversionable tool rejects pins instead of ignoring them
  Status: tested
  Given gcloud components carry no version of their own, every one tracking the installed SDK version
  When `toolPackages.gcloud` gives a package a non-empty pin, or a profile ref pins one via `{name, version}`
  Then che errors naming the tool and the package, saying the pin does not belong
  And the generated packages schema admits only null values for such a tool
  And bare entries decode as rolling, as for any other tool

Scenario: an SDK without a component manager warns instead of failing the run
  Status: tested
  Given a Google Cloud SDK installed through a package manager that disables component management
  When the profile's gcloud tool packages install
  Then they skip with a warning and the che run continues
  And `--update` refreshes through `gcloud components update`, which moves the whole SDK, the only unit gcloud versions

<!-- [<] 🤖🤖 -->
