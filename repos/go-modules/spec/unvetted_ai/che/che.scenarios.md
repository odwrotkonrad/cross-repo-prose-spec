# Feature: Che Profile as a Unit of Execution

<!-- [>] 🤖🤖 -->

Scenario: the run sequence honours the skip list (todo)
  Given `run.skipOps` lists an op
  When I invoke `run`
  Then the sequence omits that op
  And a debug line gives reason `options.run.skipOps`
  And the op's dests are left as they are, never swept

Scenario: naming an op runs it whatever the run sequence skips (todo)
  Given `run.skipOps` lists an op
  When I invoke that op as a direct subcommand
  Then it performs its mutations in full
  And no line reports it as skipped

Scenario: the skip list reads from flag, env and config alike (todo)
  When I set `run.skipOps` in the user config or spec file
  Then `run --skip-ops` overrides it
  And `CHE_RUN_SKIP_OPS` overrides the config layers below it
  And an op name outside the known set fails with a clear error

<!-- [<] 🤖🤖 -->
