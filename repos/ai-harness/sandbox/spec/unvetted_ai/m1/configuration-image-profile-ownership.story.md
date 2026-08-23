# Feature: Configuration image profile ownership

<!--[>] 🤖🤖 -->

## As a sandbox operator

Owns the image's profile declaration. Does not author the configs profiles.

### One file says what the image is made of (tested)

I want the sandbox repo's configuration-image che profile naming the profiles
the image is built from,
so that one place says what the image holds.

### Configs stays upstream, never forked (tested)

I want those sources resolving to the configs repo as a remote, no configs
profile copied into the sandbox repo,
so that a configs change needs no sandbox-side edit.

<!--[<] 🤖🤖 -->
