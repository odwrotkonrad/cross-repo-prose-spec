# Feature: Signed Apt Repo on Pages

<!-- [>] 🤖🤖 -->

Scenario: a user apt-installs the latest che (implemented)
  When a `che/vX.Y.Z` tag pipeline runs `publish-che` then `apt-build-che` and `pages-publish-tag`
  Then `che_X.Y.Z_linux_{amd64,arm64}.deb` uploads to the generic package registry and links as a release asset
  And the Pages site serves `apt/dists/stable` (component `main`) listing it
  And `apt update && apt install che` installs che into `/usr/bin`

Scenario: a user pins an exact che version at install time (implemented)
  When releases accumulate
  Then the rebuilt pool keeps every version's deb
  And `apt install che=X.Y.Z` installs that version, apt-native, no `che@X.Y.Z` package clones

Scenario: an operator runs the first deploy before any deb exists (implemented)
  When the registry holds no che debs
  Then `publish-apt` publishes only `apt/gpg.key` and exits 0

<!-- [<] 🤖🤖 -->
