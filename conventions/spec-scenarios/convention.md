# Spec Scenarios Convention

<!-- [>] 🤖🤖 -->

Behavior specs are markdown feature files, all in the `prose` repo: a repo's
specs under `prose/repos/<repo-path>/spec/<vetting>/<unit>/<feature>.md`,
prose's own system specs under its `spec/`. Gherkin-style scenarios, each with
a `Status:` line first. Downstream repos carry no spec trees: edit the
scenarios here, then implement in the repo.

## Vetting

`spec/` splits into three dirs, each holding `<unit>/<feature>.md` trees. The
dir marks what a human vetted, so what AI may touch:

- `spec/vetted/`: fully vetted. AI never touches.
- `spec/vetted_title_only/`: titles vetted. AI never touches `Scenario:` lines,
  edits the rest freely.
- `spec/unvetted_ai/`: unvetted. AI free rein. All new AI scenarios land here.

Moving files and scenarios between dirs must come from human will: the move is
the vetting act.

`technical-requirements.md` lives under a vetting dir too, prefer `vetted/`.
Unvetted requirements poison the spec tree. On add or change, AI urges the
human to vet before anything builds on it.

## Statuses

```
Statuses: todo | implemented | tested (implemented, tests in place).
```

- `todo`: specified, not implemented
- `implemented`: behavior exists, no test pins it
- `tested`: behavior exists and tests pin every Then clause

Keep the status accurate: promote to `tested` only once a test pins the
scenario's clauses, demote when implementation or tests go away.

## Shape

```
Scenario: <value this scenario brings to an audience, as a one-line description>
  Status: todo | implemented | tested
  Given <precondition>
  When <trigger>
  Then <observable outcome>
  And <further outcomes>
```

The title names the audience's gain: what a user, operator, or agent gets or is
protected from. Given/When/Then carry the mechanics.

<!-- [<] 🤖🤖 -->
