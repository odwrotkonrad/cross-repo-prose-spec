# Spec Scenarios Convention

<!-- [>] 🤖🤖 -->

Behavior specs are markdown files, all in the `prose` repo, under
`prose/repos/<repo-path>/spec/<vetting>/<unit>/`. Prose is a repo like any
other: its own system specs sit under `repos/prose/`. Behavior every repo shares
sits under `repos/shared/`. Downstream repos carry no spec trees: edit the spec
here, then implement in the repo.

Two forms, two files:

- `<feature>.story.md`: user stories. The default form.
- `<feature>.scenarios.md`: Gherkin scenarios. Only for behavior meant for
  automated BDD.

## Picking A Form

Write a user story. It states who gains what, without Given/When/Then mechanics.

Write Gherkin scenarios only when the behavior is automation-bound: a BDD runner
will drive it, the trigger is deterministic (a CLI invocation, an API call) and
the outcome is observable. Everything else stays a story.

A scenarios file always accompanies a story file of the same stem. A story file
may stand alone.

## Layout

Both forms share a stem inside the unit dir:

```
spec/unvetted_ai/telemetry/
  collection.story.md
  collection.scenarios.md
  forwarding.story.md
```

`technical-requirements.md` keeps its name, no suffix.

## Shape: User Story

```markdown
# Feature: Session telemetry

## As an operator

Runs and watches agent sessions, never authors their code.

### Debug a session without entering it (todo)

I want telemetry forwarded to one endpoint,
so that I never shell into a session to diagnose it.

### Tell one session's telemetry from another's (todo)

I want each signal to name its session,
so that I can attribute load to the right agent.
```

- H1 `# Feature: <name>`.
- H2 `## As a <role>` / `## As an <role>`. The role is stated once, every story
  below inherits it. Several roles per file allowed, each its own H2.
- Under the H2, one line describing the persona: what they do, what they do not.
  Stated once per role, never repeated in a story.
- H3: the story title, the audience's gain in one line, never restating the
  role, closing with the status in parentheses: `(todo)`.
- Body: `I want ...,` / `so that ...`, two lines, role never repeated.
- A leading prose paragraph under the H1 is welcome where the feature needs
  framing.

## Shape: Gherkin Scenario

```
Scenario: <value this scenario brings to an audience, as a one-line description> (todo | implemented | tested)
  Given <precondition>
  When <trigger>
  Then <observable outcome>
  And <further outcomes>
```

The title names the audience's gain: what a user, operator or agent gets or is
protected from. Given/When/Then carry the mechanics.

## Vetting

`spec/` splits into three dirs, each holding `<unit>/` trees. The dir marks what
a human vetted, so what AI may touch:

- `spec/vetted/`: fully vetted. AI never touches.
- `spec/vetted_title_only/`: titles vetted. AI never touches H3 story titles or
  `Scenario:` lines, edits the rest freely. The trailing status in parentheses
  is not part of the title: AI keeps it accurate.
- `spec/unvetted_ai/`: unvetted. AI free rein. All new AI specs land here.

Moving files, stories and scenarios between dirs must come from human will: the
move is the vetting act.

`technical-requirements.md` lives under a vetting dir too, prefer `vetted/`.
Unvetted requirements poison the spec tree. On add or change, AI urges the human
to vet before anything builds on it.

## Statuses

```
Statuses: todo | implemented | tested (implemented, tests in place).
```

- `todo`: specified, not implemented
- `implemented`: behavior exists, no test pins it
- `tested`: behavior exists and tests pin it

Every story and every scenario closes its title with the status in parentheses.
One place to read it, one place to change it.

On a scenario, `tested` means tests pin every Then clause. On a story, it means
tests pin the behavior the story describes, which in practice means a
`.scenarios.md` counterpart exists and its scenarios are `tested`.

Keep the status accurate: promote to `tested` only once a test pins the
behavior, demote when implementation or tests go away.

<!-- [<] 🤖🤖 -->
