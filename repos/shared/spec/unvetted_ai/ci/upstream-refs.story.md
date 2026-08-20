# Feature: Every consumer reads its upstream refs from the environment

<!-- [>] 🤖🤖🤖 -->

Each released artifact's latest version lives once, in `infra/iac`, published
as a `GRP_KO_VAR_<ARTIFACT>_REF` group variable
(`repos/infra/iac/spec/.../gitlab/ArtifactVersionVariablesBehavior.story.md`).
Consumers never write a version down: specs read
`${{ env.<ARTIFACT>_REF }}`, templates read `env.Getenv "<ARTIFACT>_REF"`, CI
derives the bare name from the group variable per the ci-variables convention,
hosts seed it into `.env` (`dev-env/upstream-refs.story.md`). No fallback
version anywhere: an unset ref fails the load by name. prose (`PROSE_REF`) is
the first artifact, the pattern holds for all.

## As a repo owner

Pins upstream artifacts in the repo's che specs and templates. Tracks no
release streams.

### A spec pin is an env ref, never a literal version (implemented)

I want every `?ref=` pin in che.yml to read `?ref=${{ env.<ARTIFACT>_REF }}`,
bare and strict,
so that an upstream bump never edits this repo and a missing version fails
loud.

### Templates fetch at the same version as specs (implemented)

I want `remoteFile` calls in `*.tpl` to build their ref from
`env.Getenv "<ARTIFACT>_REF"`,
so that specs and templates cannot resolve one upstream at two versions.

### CI derives the bare name at the pipeline boundary (implemented)

I want each pipeline consuming an upstream to assign
`<ARTIFACT>_REF: $GRP_KO_VAR_<ARTIFACT>_REF` in one line in its top-level
`variables:` block, the bare name never defined in GitLab,
so that the value has one source and its scope reads at the point of use.

### A content regen touches no pin (implemented)

I want control's per-consumer regen MR after an upstream release to re-render
at the new version and commit only rendered outputs,
so that the diff shows what the release changed, never a version string.

<!-- [<] 🤖🤖🤖 -->
