# CI Variables Convention

<!-- [>] 🤖🤖 -->

Every CI/CD variable GitLab injects carries a prefix naming the scope that
defines it:

- `GRP_<MNEMONIC>_VAR_`: defined on a group, readable by every repo under it.
  The mnemonic names the group.
- `REPO_VAR_`: defined on one project. The repo goes unnamed: the variable is
  visible only inside it.

Group mnemonics:

| group | mnemonic | prefix |
|---|---|---|
| `konradodwrot` | `KO` | `GRP_KO_VAR_` |

A subgroup defining its first variable adds a row here, in the same MR.

The prefix says where a value comes from and where to change it. An unprefixed
name is defined by the pipeline itself.

All are declared in `cross-repo/infra/iac`, never clicked into the UI: group
variables in `tf/modules/gitlab/ci-toggles.tf`, project variables beside the
resource that owns them. A key in GitLab and not in `cross-repo/infra/iac` is
drift: import or delete it.

## In The Dependency Graph

A CI variable crosses repo boundaries, so it is an artifact.
`cross-repo/infra/iac` declares each one downstream as `ci-var/<name>`, type
`ci-variable`. Every repo reading it declares
`cross-repo/infra/iac/ci-var/<name>` upstream:

```yaml
# cross-repo/infra/iac/.repo/cross-repo-interface.yml
downstream:
  - {name: ci-var/artifact-registry, type: ci-variable}

# a consumer's .repo/cross-repo-interface.yml
upstream:
  - cross-repo/infra/iac/ci-var/artifact-registry
```

The declaration answers, without grep: who reads this, what breaks if it
changes. Automation's aggregation enforces the pair: an upstream naming a
variable nobody produces fails the build.

Name the artifact for the value, not the variable: `ci-var/artifact-registry`
covers `GRP_KO_VAR_ARTIFACT_REGISTRY` and its two proxy variables, produced and
consumed as one. One artifact per value that moves independently, not per
GitLab key. A renamed prefix renames no artifact.

## Remapping At The Boundary

A prefixed name is read once. Each pipeline assigns every injected variable it
consumes to the bare name, at the boundary. Past it, jobs, scripts, Makefiles
and tools read the bare name only.

```yaml
variables:
  ARTIFACT_REGISTRY: $GRP_KO_VAR_ARTIFACT_REGISTRY
  CI_IMAGES_REF: $GRP_KO_VAR_CI_IMAGES_REF
  CHE_PACKAGES_REF: $GRP_KO_VAR_CHE_PACKAGES_REF
  CI_IMAGE: $ARTIFACT_REGISTRY/ci-linux:$CI_IMAGES_REF
```

One value, two variables:

- the **prefixed** one, declared in `cross-repo/infra/iac`, injected by GitLab.
  The value's home, the only one anything writes.
- the **bare** one, assigned from it in the pipeline. What the repo's code
  reads, and the name a tool expects (`glab` reads `GITLAB_TOKEN`, Terraform
  `TF_VAR_*`, che `CHE_PACKAGES_REF`).

One line per variable, the supplying scope visible where the value enters. A
script reading `$GRP_KO_VAR_...` directly is a defect: it runs only under
GitLab, and a local run cannot feed it from `.env`.

Where the line goes depends on how far the bare name may reach:

- group variables the whole pipeline wants: the top-level `variables:` block.
- project secrets: the job that uses them, never top-level.
- values that change a tool's behaviour under test: the jobs that want them. A
  suite asserting a tool's default must not inherit a variable overriding that
  default. `GRP_KO_VAR_CHE_BACKUP_AUTO_CREATE` is group-scoped for this reason:
  one place sets it, each repo picks which jobs see it as
  `CHE_BACKUP_AUTO_CREATE`.

Never define the bare name in GitLab. Two GitLab-defined variables holding one
value drift the moment somebody edits the wrong one, and neither records which
is authoritative. The assignment is derivation in a reviewed file, not a second
source of truth.

## `.env.tpl`

Every repo whose pipeline remaps a variable tracks `.env.tpl` at its root (the
shared git ignore re-includes it under the `**/.*` rule). A gomplate template
che renders to `.env` (gitignored, `mergeUpsert`), the only env template a repo
has: no `templates/1-env/`, no `.env.example`, no second seed. One line per
bare name the pipeline derives, each fetching its value the way a host can:

```sh
ARTIFACT_REGISTRY={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_ARTIFACT_REGISTRY" }}
CI_IMAGES_REF={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_CI_IMAGES_REF" }}
GITLAB_TOKEN={{ secret "op://ProgrammaticAccess/gitlab/access_token" }}
MK_DRY_RUN=
```

What CI derives from GitLab, a host fetches through `glab`, a secret through
`op`, a local-only knob as a plain or empty value. Under `mergeUpsert` a
`shell` or `secret` value overwrites the existing key on every render, a plain
value keeps it: `| keepIfExisting` or `| alwaysUpdate` overrides per line. The
two lists match: a variable added to one is added to the other in the same
change. Spec: `repos/shared/spec/unvetted_ai/dev-env/env-template.story.md`.

## Naming

After the prefix, the name says what the value is, not who reads it:
`GRP_KO_VAR_ARTIFACT_REGISTRY`, not `GRP_KO_VAR_DOCKER_LOGIN_TARGET`. The bare
name is the prefixed name minus its prefix, unless a tool dictates another
spelling (`TF_VAR_github_token: $REPO_VAR_GITHUB_TOKEN`).

Versions end in `_REF`. Each released producer publishes its own:
`GRP_KO_VAR_PROSE_ASSETS_REF` (`cross-repo/prose/assets`),
`GRP_KO_VAR_PROSE_SPEC_REF` (`cross-repo/prose/spec`), `GRP_KO_VAR_MISC_REF`
(`cross-repo/misc`), `GRP_KO_VAR_CHE_PACKAGES_REF`, `GRP_KO_VAR_CI_IMAGES_REF`.
A consumer pins each upstream independently: a spec edit never moves the assets
pin.

## What Is Not A CI Variable

A value neither secret nor environment-specific belongs in the file that uses
it. A CI variable is for what cannot be committed (a token) or what one place
must own for everyone (a registry host, a pinned version). Everything else is
configuration, reviewed in an MR.

Variables a trigger job passes downstream (`forward.yaml_variables`) are
pipeline-defined: no prefix, no declaration in `cross-repo/infra/iac`.

## Example

Runnable version in `example/`: a `.gitlab-ci.yml` remapping every injected
variable at the boundary, the Terraform declaring them, the matching
`.env.tpl`.

<!-- [<] 🤖🤖 -->
