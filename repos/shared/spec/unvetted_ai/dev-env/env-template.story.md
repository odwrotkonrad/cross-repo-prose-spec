# Feature: `.env.tpl` is the one template `.env` renders from

<!-- [>] 🤖🤖 -->

A repo that uses `.env` tracks exactly one env file: `.env.tpl` at its
root. It is a gomplate template che renders to `.env` (gitignored,
`mergeUpsert`), not a static list to copy. A plain value stays a plain value,
a secret is `{{ secret "op://..." }}`, a GitLab variable is
`{{ shell "glab variable get -g konradodwrot GRP_KO_VAR_<NAME>" }}`. No
`templates/1-env/`, no second seed template, no hand-copied `.env`.

## As a developer

Clones a repo, runs `make repo-prepare-dev-env`. Types no value by hand.

### One file names every variable a checkout needs (implemented)

I want `.env.tpl` to list every bare name the repo's pipeline derives and
every local-only variable the Makefile reads, each line either a value, an
empty value, or a template expression that fetches one,
so that reading one file tells me the whole environment and nothing else
defines a key.

### `.env` renders from it, nothing else writes `.env` (implemented)

I want `repo-prepare-dev-env` to render `.env.tpl` to `.env` through che
`renderTemplates` (`writeType: mergeUpsert`, `.env` gitignored),
so that a fresh checkout gets a working `.env` in one command and my manual
additions survive a re-render.

### prose seeds its own `.env` (todo)

I want prose carrying the `envSeed` profile and `repo-render-env` its
`.env.tpl` already presumes,
so that `make tag-mint` on a prose checkout reads `TAG_TOKEN` the way CI does.

### A re-render refreshes fetched values, keeps hand-added ones (implemented)

I want a `shell` or `secret` value in `.env.tpl` to overwrite the existing
key on every render by default, `| keepIfExisting` to opt a line out and
`| alwaysUpdate` to opt any other value in (`repos/go-modules/spec/.../che/render-merge-action.story.md`),
and a key I added to `.env` by hand, absent from the template, to stay,
so that a bumped group variable or a rotated secret reaches my checkout on
the next `make`, without the render discarding what only I know.

### Secrets resolve at render time (implemented)

I want a secret written as `{{ secret "op://<vault>/<item>/<field>" }}` and
resolved when `.env` renders, never as a committed value,
so that the template is safe to track and the host's 1Password session is
the only credential involved.

### GitLab variables resolve through glab (implemented)

I want a value that CI derives from a GitLab variable written as
`{{ shell "glab variable get -g konradodwrot GRP_KO_VAR_<NAME>" }}` (or the
project form for `REPO_VAR_`), the bare name on the left matching the
pipeline's remap line,
so that the host and CI read the same value from the same source, and a
bump in `infra/iac` reaches my checkout on the next render.

### A missing tool fails by name (implemented)

I want an unauthenticated `glab` or `op` to fail the render naming the key,
never to leave an empty or partial value,
so that a broken environment is a loud error at prepare time, not a silent
failure later.

## As a repo maintainer

Owns the repo's `che.yml`, Makefile and `.env.tpl`.

### Adding a variable is one line (implemented)

I want a new pipeline remap or a new local variable to be one added line in
`.env.tpl` and nothing else (no new template, no Makefile target),
so that the template and the pipeline cannot drift apart by layout.

### The render skips what it cannot resolve when asked (implemented)

I want `skipSecrets` and `skipVariables` to skip the whole template when on,
leaving an existing `.env` untouched,
so that a CI job or a dry run without `op` or `glab` renders everything
else.

### The template is tracked, the render is not (implemented)

I want `.env.tpl` tracked in every repo despite the host's global
`**/.*` ignore (the shared git ignore in `configs` re-includes
`!**/.env.tpl`, as it did `.env.example`), and `.env` ignored,
so that a clone carries the template and never a rendered value.

### configs stops tracking `.env` (todo)

I want configs' committed `.env` untracked and ignored like every other repo's,
so that no clone carries a rendered value.

### Every repo wires it the same way (implemented)

I want the `.env.tpl` → `.env` entry in every repo's `che.yml` to read
identically (same source, same dest, same options), under the profile
`repo-prepare-dev-env` renders,
so that preparing any checkout needs no reading of its spec.

<!-- [<] 🤖🤖 -->
