# Feature: Env Interpolation In Che Specs

<!-- [>] 🤖🤖🤖 -->

Scenario: a config author parameterizes any string value from the launch env (tested)
  Given a che.yml with `${{ env.TREE }}/**` in a glob and `${{ env.APP }}` in a ctx value
  And `TREE=root` and `APP=web` are exported
  When I invoke `che discover`
  Then the discovered plan shows `root/**` and `web` in place of the refs
  And every mapping key reads exactly as written

Scenario: .env feeds the launch env, the shell's export wins (tested)
  Given `.env` beside the root che.yml holds `A=file` and `B=file`
  And `B=shell` is exported
  And the che.yml uses `${{ env.A }}` and `${{ env.B }}`
  When I invoke `che discover`
  Then `A` resolves to `file`
  And `B` resolves to `shell`

Scenario: a fallback supplies the value when nothing is exported (tested)
  Given a che.yml with `${{ env.PORT || 8080 }}`
  And `PORT` is unset
  When I invoke `che discover`
  Then the value is the string `8080`
  And no error is raised under either envUnset policy

Scenario: every unset required var is named in one error (tested)
  Given a che.yml with bare `${{ env.A }}` and `${{ env.B }}` at two paths
  And `A` and `B` are unset
  And envUnset resolves to `error`
  When I invoke `che discover`
  Then the load fails with one error naming the spec path
  And the error lists `A` and `B` each with its YAML path

Scenario: a selective run ignores vars of profiles it does not execute (tested)
  Given a che.yml with profile `a` using `${{ env.A }}` and profile `b` using `${{ env.B }}`
  And `A=x` is exported and `B` is unset
  And envUnset resolves to `error`
  When I invoke `che run --profiles a`
  Then profile `a` runs with `x`
  And no error mentions `B`

Scenario: a profile skipped by runIf never demands its vars (implemented)
  Given profile `b` carries `runIf: ['os:linux']` and uses `${{ env.B }}`
  And the host is darwin and `B` is unset
  When I invoke `che run`
  Then discovery skips `b`
  And no error mentions `B`

Scenario: a selected profile's unset var still fails (tested)
  Given the same che.yml
  When I invoke `che run --profiles a,b`
  Then the run fails naming `B` at its YAML path under `b`

Scenario: the empty policy turns unset refs into empty strings (tested)
  Given the same che.yml
  When I invoke `che --env-unset empty discover`
  Then the load succeeds
  And both refs resolve to the empty string

Scenario: a sourced ref's env reaches the referenced spec at load (tested)
  Given a consumer che.yml sourcing `shared//che.yml::app` with `env: {APP_NAME: web}`
  And the referenced spec uses `${{ env.APP_NAME }}` and declares `env: {APP_NAME: generic}`
  When I invoke `che discover` in the consumer
  Then the referenced spec's values read `web`

Scenario: discover reports the tree's env requirements (tested)
  Given a spec tree with one bare ref set, one bare ref unset and one defaulted ref
  When I invoke `che discover`
  Then an env requirements section lists each ref per spec
  And each line states required or its default, and set or unset
  And discovery completes without error

Scenario: a template reads a spec env value through gomplate (implemented)
  Given a profile with `env: {NAME: x}` rendering a template containing `{{ env.Getenv "NAME" }}`
  When I invoke `che render-templates`
  Then the output contains `x`
  And the process env after the profile no longer carries `NAME`


<!-- [<] 🤖🤖🤖 -->
