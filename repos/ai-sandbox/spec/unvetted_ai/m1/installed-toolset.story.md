# Feature: Installed toolset

<!--[>] 🤖🤖 -->

## As a session user

Works in the session with the tools they know. Does not install them.

### The agents the sandbox exists to run are there (todo)

I want claude and codex both running in a session booted from the configuration
image,
so that a session is useful the moment it starts.

### The shell, terminal and editor behave as on the host (todo)

I want zsh, tmux and vim running configured as they are on the host,
so that muscle memory carries into the sandbox.

### Every workspace repo builds without setup (todo)

I want go, python, ruby and node present,
so that no session begins with a toolchain install.

### GCP is reachable from the shell (todo)

I want gcloud present,
so that the session can use the identity it holds.

## As a sandbox operator

Decides which profiles the image carries. Does not use the tools day to day.

### The dev profile tree lands whole (todo)

I want every profile under the configs dev tree applied at image build,
so that the image tracks the profile tree rather than a hand-kept list.

### The heavy profiles stay out (todo)

I want neither ollama nor observability applied,
so that the image stays small and the sandbox stays a workstation.

<!--[<] 🤖🤖 -->
