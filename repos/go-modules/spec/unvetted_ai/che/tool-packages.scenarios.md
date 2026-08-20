# Feature: Tool-Scoped Packages (toolPackages)

<!-- [>] 🤖🤖 -->

Scenario: a user installs tool packages directly via --kind (implemented)
  When I run `che packages install --kind=vscode <name...>`
  Then each name resolves in `toolPackages.vscode` (unknown name: hard error naming the file)
  And a present package with a matching pin skips, a drifted pin reinstalls, `--update` refreshes unpinned ones
  And dry-run prints the would-be installs without running the tool
  And `che packages check-present --kind=vscode` errors on missing entries, defaulting to the profiles' selection, else the whole section

Scenario: a GKE user gets gcloud components declared, not hand-installed (tested)
  Given `basePackages.gcloud` names `gcloud`, so the SDK installs through the regular pipeline first
  When a profile includes `installToolPackages: {gcloud: [gke-gcloud-auth-plugin]}`
  Then the component installs via `gcloud components install --quiet <id>`
  And presence comes from `gcloud components list`, any state but `Not Installed` counting as installed
  And a second run reports it installed and runs nothing

Scenario: an unversionable tool rejects pins instead of ignoring them (implemented)
  Given gcloud components carry no version of their own, all tracking the installed SDK
  When `toolPackages.gcloud` pins a package, or a profile ref pins one via `{name, version}`
  Then che errors naming the tool and the package
  And the generated packages schema admits only null values for such a tool
  And bare entries decode as rolling, as for any other tool

<!-- [<] 🤖🤖 -->
