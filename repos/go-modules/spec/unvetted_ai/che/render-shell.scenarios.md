# Feature: Shell Commands In Templates

<!-- [>] 🤖🤖🤖 -->

Scenario: a command's stdout renders into the template (tested)
  Given a template with `{{ shell "printf '%s' \"$NAME\"" }}`
  And the profile declares `env: {NAME: x}`
  When I invoke `che render-templates`
  Then the output contains `x`
  And the command ran under `$SHELL`, else the account's login shell, else `sh`

Scenario: a failing command fails the render by name (tested)
  Given a template with `{{ shell "exit 3" }}`
  When I invoke `che render-templates`
  Then the render fails naming the template, the command and the exit status
  And no output file is written

Scenario: skipVariables withholds templates that shell out (tested)
  Given one template with a `shell` call and one without
  And `options.renderTemplates.skipVariables` is true
  When I invoke `che render-templates`
  Then the template without the call renders
  And the other is skipped, its dest logged with `options.renderTemplates.skipVariables`

Scenario: skipSecrets does not touch shell calls (tested)
  Given a template with a `shell` call and no secret ref
  And `options.renderTemplates.skipSecrets` is true
  When I invoke `che render-templates`
  Then the command runs and the template renders

<!-- [<] 🤖🤖🤖 -->
