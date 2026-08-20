# Feature: Che Discover Operation

<!-- [>] 🤖🤖 -->

Scenario: a config author previews a run without touching the host (tested)
  When I invoke `discover-profiles` standalone
  Then the log lists discovered profiles
  And each profile lists the os-mutating operations it would perform

Scenario: the discovery plan prints with no log-level tuning (tested)
  Given `CHE_LOG_LEVEL` is unset
  When I invoke `discover-profiles` standalone or any os-mutating che command
  Then the log lists discovered profiles

Scenario: opting out of auto-discovery gets a clear ask for --profiles (tested)
  Given options.autoDiscover is false (che config, default true)
  When I invoke a che command without --profiles
  Then the command errors asking for --profiles
  And forced profiles and sourced refs still run

<!-- [<] 🤖🤖 -->
