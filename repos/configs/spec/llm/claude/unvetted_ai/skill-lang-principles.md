<!--[>] 🤖🤖 -->
Feature: language principles option on the code skills

Scenario: an agent applies the user's Go design principles by naming the language on a code skill
  Status: implemented
  Given the claude rules carry code/go/principles.md
  When the user runs a code skill with scope and the lang argument go
  Then the skill prints the Go principles into its Language Principles section
  And the agent applies them to every Go target in scope

Scenario: an agent applies the user's Python design principles the same way it applies the Go ones
  Status: implemented
  Given the claude rules carry code/python/principles.md
  When the user runs a code skill with scope and the lang argument python
  Then the skill prints the Python principles into its Language Principles section
  And the agent applies them to every Python target in scope

Scenario: an agent applies the user's Ruby design principles the same way it applies the Go ones
  Status: todo
  Given the claude rules carry code/ruby/principles.md
  When the user runs a code skill with scope and the lang argument ruby
  Then the skill prints the Ruby principles into its Language Principles section
  And the agent applies them to every Ruby target in scope

Scenario: Ruby design principles carry the language's own idiom, not a translation of the Go ones
  Status: todo
  Given the Go and Python principles files set the section shape
  When the Ruby principles file is authored
  Then it covers objects, modules, duck typing, blocks and Enumerable as Ruby's own concerns
  And it carries design-level principles only, no frontmatter paths key

Scenario: Python design principles stay separate from the path-scoped Python rules
  Status: implemented
  Given code/python/python.md and code/python/scripts.md auto-attach by path and cover typing, docstrings and script structure
  When the Python principles file is authored
  Then it carries design-level principles only, no frontmatter paths key
  And it restates nothing already covered by the path-scoped rules

Scenario: a user naming an unsupported language gets told which one failed instead of a silent skip
  Status: implemented
  When the user runs a code skill with a lang argument that has no principles file
  Then the skill fails with unknown lang and the resolved path
  And the skill runs with no principles section when the lang argument is omitted

Scenario: the principles reach the host through the same prose-to-configs render path as every other claude rule
  Status: implemented
  Given prose owns the claude rules and configs renders them at a pinned prose version
  When a principles file is added under the prose claude-rules tree and wired into the configs render spec
  Then rendering configs writes it under the claude rules tree in the repo
  And loading configs onto the host puts it where the skill script reads it
<!--[<] 🤖🤖 -->
