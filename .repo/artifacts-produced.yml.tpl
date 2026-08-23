##[>] 🤖
produces:
  - uri: gitlab.com/konradodwrot/cross-repo/prose/spec
    type: gitRepository
    versionEnvVar: PROSE_SPEC_REF
    version: {{ env.Getenv "PROSE_SPEC_REF" }}
##[<] 🤖
