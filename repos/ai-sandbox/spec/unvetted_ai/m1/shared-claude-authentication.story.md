# Feature: Shared claude authentication

<!--[>] 🤖🤖 -->

## As a session user

Starts claude and works. Never logs in.

### A new session is already logged in (implemented)

I want claude authenticated in the configuration image, running with no login
asked of anyone,
so that session start costs no interaction.

### Every session shares the one authentication (implemented)

I want two sessions on the same image both authenticated, neither logged in
separately, later sessions the same,
so that one authentication serves all.

### A broken image says so instead of prompting (implemented)

I want a build that captures no authentication failing and naming the missing
credential,
so that a build defect is not handed to the user as a login.

### A missing credential fails loudly in the session (todo)

I want claude on an unauthenticated image failing, no login prompt,
so that a login screen never reaches a session.

## As a sandbox operator

Provisions the credential at build time. Does not attach to sessions.

### The credential is taken from the host, unattended (implemented)

I want a host-held claude credential written into the configuration image, no
login performed, no login container started,
so that the build stays hands-off where it can.

### The interactive fallback is one login, then gone (implemented)

I want a login container booted only when no unattended flow exists,
capturing the credential and shutting down, never an attachable session,
so that the manual path costs one prompt and leaves nothing behind.

### Authentication belongs to the image, not the session (todo)

I want a stopped session's data holding no claude authentication,
so that session data cannot carry the credential out.

<!--[<] 🤖🤖 -->
