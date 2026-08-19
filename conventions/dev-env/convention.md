# Dev Environment Convention

<!-- [>] 🤖🤖 -->

Every repo exposes `repo-prepare-dev-env`, turning a fresh clone into a working
checkout. Specified in
`prose/repos/shared/spec/unvetted_ai/dev-env/prepare.story.md`.

## The Target

A wrapper (prerequisite chain, no recipe), in a `[genai-include]` section so it
reaches the generated `assets/data/makefile.agents.md`:

```make
##[>] Dev Environment [genai-include]
#[what] make a fresh clone a working checkout: generated docs, dependencies, git hooks
repo-prepare-dev-env: render-templates repo-prepare-deps repo-ci-prepare-hooks
##[<] Dev Environment
```

Order is fixed: **render, then dependencies, then hooks**. The `docsgen`
pre-commit hook runs `render-templates` and fails on drift, so hooks installed
before the first render leave a fresh clone unable to commit.

- `repo-prepare-deps` is the uniform name for the dependency step, even where it
  only delegates to an existing target. A repo needing no dependencies omits it
  and chains render and hooks alone.
- Only real prerequisites belong in the chain. A target producing build artifacts
  is an output, not a prerequisite: preparing an environment is not building the
  project.
- Every step upserts, so re-running on a prepared checkout is safe and quiet.

## Declaring A Toolchain

A repo needing a language or tool declares it in its own `che.yml` rather than
assuming the host carries it:

```yaml
devEnv:
  include:
    installPackages:
      - ruby
```

`repo-prepare-deps` runs `che run --profiles=devEnv` before the language-native
step (`bundle install`, `python -m venv`), so the toolchain exists when that step
needs it. Packages come from the shared catalog.

A toolchain many repos share belongs in the `configs` profile that seeds hosts
and images, so it is installed once rather than per repo.

## Workspace Driving

`control`'s workspace profile prepares every cloned repo between cloning and
indexing: the index inlines each repo's rendered purpose doc, which does not
exist until that repo renders. The driver holds no per-repo knowledge — it calls
the target, skips repos that do not define one, reports failures, and always
succeeds, so one broken checkout cannot abort a session bootstrap or an image
build.

## Example

Runnable version in `example/`: `Makefile`, `che.yml`.

<!-- [<] 🤖🤖 -->
