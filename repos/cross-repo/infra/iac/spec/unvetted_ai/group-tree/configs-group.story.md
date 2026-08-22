# Feature: Host configuration lives under one configs group

<!-- [>] 🤖🤖 -->

`configs` held tool dotfiles, the AI toolchain and the per-host assembly in one
repo, one release stream. A `configs` group splits them: `tools`, `ai-tools`,
`hosts`, each tagged on its own.

## As the group owner

Declares the GitLab tree in Terraform, applies it through CI, never clicks.

### The configs repo becomes configs/tools with its history (todo)

I want the `configs` project transferred into the new `configs` group as
`tools`, id, history, tags, MRs and variables intact, the GitHub mirror
renamed to `configs-tools`,
so that the tool profiles keep their past and nothing is recreated.

### ai-tools and hosts start empty beside it (todo)

I want `configs/ai-tools` and `configs/hosts` declared in the same change,
public, mirrored, on the tagging list,
so that every repo of the group releases the way the others do.

### Each split repo publishes a pin (todo)

I want `GRP_KO_VAR_CONFIGS_TOOLS_REF` and `GRP_KO_VAR_CONFIGS_AI_TOOLS_REF`
declared here, one `.auto.tfvars` each,
so that `hosts` and the sandbox pin tools and ai-tools independently.

<!-- [<] 🤖🤖 -->
