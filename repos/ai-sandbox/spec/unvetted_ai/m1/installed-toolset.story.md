# Feature: Installed toolset

<!--[>] 🤖🤖 -->

## As a session user

Works in the session with the tools they know. Does not install them.

### The agents the sandbox exists to run are there (implemented)

I want claude and codex both running in a session booted from the configuration
image,
so that a session is useful the moment it starts.

### The shell, terminal and editor behave as on the host (implemented)

I want zsh, tmux and vim configured as on the host,
so that muscle memory carries into the sandbox.

### Every workspace repo builds without setup (implemented)

I want go, python and ruby present,
so that no session starts with a toolchain install.

### The js repos build like the rest (todo)

I want node present,
so that no session starts with an nvm install.

### GCP is reachable from the shell (implemented)

I want gcloud present,
so that the session can use the identity it holds.

## As a sandbox operator

Decides which profiles the image carries. Does not use the tools day to day.

### The dev profile tree lands whole (implemented)

I want the configs dev virt linux profile applied at image build,
so that the image tracks configs, not a hand-kept list.

### No dev profile is left behind (todo)

I want js/node and editors/vscode applied with the rest of the dev tree,
so that the tree and the image never disagree.

### The heavy profiles stay out (implemented)

I want neither ollama nor observability applied,
so that the image stays small and the sandbox stays a workstation.

<!--[<] 🤖🤖 -->
