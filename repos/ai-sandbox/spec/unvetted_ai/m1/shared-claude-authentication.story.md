# Feature: Shared claude authentication

<!--[>] 🤖🤖 -->

## As a session user

Starts claude and works. Does not log in.

### A new session is already logged in (todo)

I want claude authenticated in the configuration image and running without
asking anyone to log in,
so that session start costs no interaction.

### Every session shares the one authentication (todo)

I want two sessions on the same image both authenticated with neither logged in
separately, and later sessions the same,
so that authenticating once serves all of them.

### A broken image says so instead of prompting (todo)

I want claude on an image carrying no authentication failing and naming the
missing authentication, with no login prompt,
so that a build defect is not handed to the user as a login.

## As a sandbox operator

Provisions the credential at build time. Does not attach to sessions.

### The credential is taken from the host, unattended (todo)

I want a host-held claude credential written into the configuration image with
no login performed, and no login container started,
so that the build stays hands-off where it can.

### The interactive fallback is one login, then gone (todo)

I want a container booted for the login only when no unattended flow exists,
capturing the credential and shutting down, never becoming an attachable
session,
so that the manual path costs one prompt and leaves nothing behind.

### Authentication belongs to the image, not the session (todo)

I want a stopped session's own data holding no claude authentication,
so that session data cannot carry the credential out.

<!--[<] 🤖🤖 -->
