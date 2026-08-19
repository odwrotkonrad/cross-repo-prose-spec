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
- The step installs both halves: the **toolchain** the repo declares (below), then
  the **project dependencies** that toolchain manages (`bundle install`,
  `python -m venv`, `terraform init -backend=false`). After it, the repo is
  buildable and testable with nothing left to install by hand.
- Dependencies install **into the checkout**, never system-wide: a prepare must not
  need root. Where the tool's default is a system path, the step sets the local one
  explicitly rather than relying on a gitignored config file a fresh clone lacks.
- Only real prerequisites belong in the chain. A target producing build artifacts
  is an output, not a prerequisite: preparing an environment is not building the
  project. Nor does it reach for remote state or any credential: installing
  providers is preparation, initialising a state backend is not.
- Prefer a tool already on `PATH` over building one. A repo that can build its own
  toolchain builds only when none is installed, so preparing a fresh clone never
  waits on a compile.
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

A declared toolchain is not always a usable one: a distro package may ship a
versioned binary (`bundle3.1`) with no unversioned name, or omit the package
manager's own launcher. The step checks for the command it is about to call and
installs it when absent, rather than assuming the toolchain package supplied it.

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
