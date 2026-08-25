##[>] 🤖🤖
{{ localFile ".repo/upstream.env" | alwaysUpdate }}
PROSE_SPEC_REF={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_PROSE_SPEC_REF" }}
ARTIFACT_REGISTRY={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_ARTIFACT_REGISTRY" }}
TAG_TOKEN={{ shell "glab variable get -R konradodwrot/cross-repo/prose/spec REPO_PROTECTED_VAR_BOT_TAG_TOKEN" }}
##[<] 🤖🤖
