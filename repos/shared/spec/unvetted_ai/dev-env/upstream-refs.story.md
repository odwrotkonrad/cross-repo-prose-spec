# Feature: A fresh checkout learns its upstream refs without a hardcoded version

<!-- [>] 🤖🤖🤖 -->

Every upstream artifact a repo consumes (prose first, any
`GRP_KO_VAR_<ARTIFACT>_REF` later) has its latest version in a GitLab group
variable. In CI the variable is injected and the unprefixed `<ARTIFACT>_REF`
derived at the pipeline boundary (`ci/upstream-refs.story.md`). On a host nothing
injects it: the repo's `.env` must carry every `<ARTIFACT>_REF`, each seeded
from its group variable through `glab variable get` run by che's `shell`
template function, glab authenticated as the host already has it. che sources
`.env` itself beneath the process env (a shell export always wins). The seed
render needs no ref itself, everything else does, hence two passes, both in
one shell, both inside `repo-prepare-dev-env`.

## As a developer

Clones any repo onto a new machine, runs `make`. Exports nothing by hand.

### The env seed fetches every upstream ref from GitLab (implemented)

I want the repo's env seed template to upsert one
`<ARTIFACT>_REF={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_<ARTIFACT>_REF" }}`
line per upstream onto `.env`, `.env.tpl` documenting each key,
so that the checkout's versions are the group's latest, never copies typed in.

### The seed renders before any ref is known (implemented)

I want `repo-render-env` to render only the env-seeding profile under
`CHE_ENV_UNSET=empty`,
so that the first pass on a clean checkout succeeds with nothing exported.

### The full render follows in the same shell (implemented)

I want `repo-prepare-dev-env` to chain `repo-render-env` before the strict
render, che reading the just-rendered `.env` for every `<ARTIFACT>_REF`, an
exported value overriding the file's, a bare `make render-templates` on a
checkout with no seed failing by the var's name,
so that a clean checkout reaches a working state in one `make`, no reload, no
fallback version ever written, and no routine render pays a network call.

### A local checkout follows the authority without re-seeding (implemented)

I want control's watcher to read the current version from `infra/iac`'s tfvars
(the newest tag when iac is not checked out), rewrite `PROSE_REF` in each
consumer's gitignored `.env` and re-render its non-checked-out outputs,
so that the seed is a bootstrap, not the only time a checkout learns a version.

### A repo without upstreams skips the seed (implemented)

I want `repo-render-env` optional, repos with no `<ARTIFACT>_REF` to seed
chaining straight to the full render,
so that the pattern costs nothing where it is not needed.

## As a repo maintainer

Owns one repo's specs, templates and Makefile. Never edits a version.

### A new upstream is one more seed line (implemented)

I want adopting another upstream artifact to be one line in `.env.tpl`,
nothing else in the repo knowing the version,
so that the pattern scales to every artifact without new mechanism.

### The same targets work in every repo (implemented)

I want `repo-render-env` and the env-seeding profile named alike across repos,
so that preparing any checkout needs no reading of its Makefile.

<!-- [<] 🤖🤖🤖 -->
