# Feature: SSH keys

<!--[>] 🤖🤖 -->

## As a session user

Pushes and signs from the session. Does not manage the keys.

### Git over ssh works from the session (todo)

I want the sandbox auth key authenticating ssh to gitlab,
so that pushing needs no per-session key setup.

### Commits come out verified (implemented)

I want the signing key producing commits gitlab reports as verified,
so that sandbox commits meet the same bar as host ones.

## As a security owner

Issues and separates the keys. Does not commit.

### One role cannot stand in for the other (implemented)

I want the auth key and signing key as distinct keypairs,
so that a leaked auth key cannot forge signatures.

### Sandbox work is attributable to a person (implemented)

I want a commit's author and signature both naming the operating user,
so that history reads the same whoever typed it.

<!--[<] 🤖🤖 -->
