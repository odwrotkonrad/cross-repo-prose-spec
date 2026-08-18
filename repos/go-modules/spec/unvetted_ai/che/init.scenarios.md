# Feature: Che Init Operation

<!-- [>] 🤖🤖 -->

Scenario: an unfetchable, uncached remote stops the run (tested)
  When a remote source fails to fetch and no cached checkout exists
  Then init errors and the command aborts

Scenario: a cached checkout stands in for an unreachable remote (tested)
  When a remote source fails to update but a cached checkout exists
  Then a warning `fetch failed, using cached checkout <path>` logs and the cached checkout is used

Scenario: each remote's fate logs in one line: cloned, updated, or up to date (tested)
  When init-remote-sources ensures a source
  Then a fresh checkout logs one info line `cloned remote <git-url> into <path>`
  And an updated checkout logs one info line `updated remote <git-url> into <path>`
  And an up-to-date checkout logs one info line `up to date remote <git-url> into <path>`
  And the cache path abbreviates the home prefix to `~`

Scenario: every remote checkout lands under one predictable cache dir (tested)
  When a remote source clones
  Then its checkout lives under `<cache-home>/che/remote-sources/<slug>`

Scenario: skipRemoteRefs works fully offline, no fetch attempted (tested)
  Given skipRemoteRefs is set
  When init runs
  Then no remote source fetches

<!-- [<] 🤖🤖 -->
