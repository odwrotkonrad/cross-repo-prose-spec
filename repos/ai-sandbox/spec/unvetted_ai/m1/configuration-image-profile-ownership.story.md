# Feature: Configuration image profile ownership

<!--[>] 🤖🤖 -->

## As a sandbox operator

Owns the image's profile declaration. Does not author the configs profiles.

### One file says what the image is made of (todo)

I want the sandbox repo's configuration-image che profile naming the profiles
the image is built from,
so that the image's contents are read in one place.

### Configs stays upstream, never forked (todo)

I want those sources resolving to the configs repo as a remote, with no copy of
a configs profile in the sandbox repo,
so that configs changes need no sandbox-side edit.

<!--[<] 🤖🤖 -->
