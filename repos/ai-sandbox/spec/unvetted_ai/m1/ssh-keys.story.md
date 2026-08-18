# Feature: SSH keys

<!--[>] 🤖🤖 -->

## As a session user

Pushes and signs from the session. Does not manage the keys.

### Git over ssh works from the session (todo)

I want the sandbox auth key authenticating an ssh connection to gitlab,
so that pushing needs no per-session key setup.

### Commits come out verified (todo)

I want the signing key signing a commit that gitlab reports as verified,
so that sandbox commits meet the same bar as host ones.

## As a security owner

Issues and separates the keys. Does not commit.

### One role cannot stand in for the other (todo)

I want the auth key and signing key to be distinct keypairs,
so that a leaked auth key cannot forge signatures.

### Sandbox work is attributable to a person (todo)

I want a commit's author and signature both naming the operating user,
so that history reads the same whoever typed it.

<!--[<] 🤖🤖 -->
