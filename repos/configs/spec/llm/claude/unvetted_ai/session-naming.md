<!--[>] 🤖🤖 -->
Feature: claude automatic session naming

Scenario: the session picker shows the topic, not a directory slug
  Status: implemented
  Given claude names a session after its cwd, like configs-18
  When the session settles on a topic
  Then a UserPromptSubmit hook renames it after that topic
  And the name reads as the work, like prose-control-centralization

Scenario: the rename lands where every surface reads it
  Status: implemented
  Given the session record sits at ~/.config/claude/sessions/<pid>.json
  When the hook renames the session
  Then it writes name and drops nameSource, as /rename does
  And the ccstatusline session-name segment shows the new name

Scenario: haiku keeps the expensive model off most prompts
  Status: implemented
  Given naming runs in two layers
  When the user submits a prompt
  Then haiku reads the current name and recent prompts, and decides rename or keep
  And the naming model runs only on rename
  And keep ends the hook with no second call

Scenario: a steady topic keeps its name
  Status: implemented
  Given the session name still fits the work
  When the user submits another prompt on the same topic
  Then haiku decides keep
  And the name does not change

Scenario: a session that turns to new work gets a new name
  Status: implemented
  Given the session carries a name from earlier work
  When later prompts shift it to another topic
  Then haiku decides rename
  And the naming model names the new topic

Scenario: the hook owns the name, /rename included
  Status: implemented
  Given the user renamed the session with /rename
  When the hook next decides rename
  Then it overwrites that name
  And nameSource stays absent

Scenario: naming never delays the prompt
  Status: todo
  Given the hook runs async
  When the user submits a prompt
  Then the turn starts without waiting on either model
  And a failed call leaves the name untouched

Scenario: models stay configurable alongside the other llm scripts
  Status: implemented
  Given /etc/custom/llm.yml registers llm-* scripts with provider, model, template
  When the naming script runs
  Then it resolves provider, model, and template from that registry
  And each layer resolves its model independently
<!--[<] 🤖🤖 -->
