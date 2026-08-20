# Feature: Versioned Brew Formulae

<!-- [>] 🤖🤖 -->

Scenario: a user installs the latest che with a plain tap and install (implemented)
  When a `che/vX.Y.Z` tag pipeline runs `publish-brew`
  Then `Formula/che.rb` (class `Che`) commits to the tap at that version
  And `brew tap odwrotkonrad/tap && brew install che` installs it from the GitHub mirror

Scenario: a user pins an exact che version at install time (implemented)
  When a `che/vX.Y.Z` tag pipeline runs `publish-brew`
  Then `Formula/che@X.Y.Z.rb` also commits to the tap
  And its class name follows Homebrew's formula naming, `che@0.0.67` -> `CheAT0067`
  And `brew install che@X.Y.Z` installs that version

Scenario: an operator dry-renders both formulae locally, no tap write (implemented)
  Given `RENDER_ONLY=1`
  When `publish-brew` runs
  Then both formula files render to disk and the script exits before any tap commit

<!-- [<] 🤖🤖 -->
