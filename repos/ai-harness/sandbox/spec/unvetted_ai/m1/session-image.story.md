# Feature: Session image

<!--[>] 🤖🤖 -->

## As a sandbox operator

Builds and ships the base image. Configures no tools in it.

### One image serves every session (implemented)

I want every session pod running the one built session image, no per-session
build,
so that there is a single artifact to reason about.

### A session start pulls nothing (todo)

I want a session starting from the image already on the node,
so that creation is not gated on a registry.

### The base holds only what a session cannot install itself (implemented)

I want zsh, the session user's home and che present, no configuration-image
content baked in,
so that the base changes rarely.

### Nothing a profile installs rides the base (todo)

I want tmux, vim, gcc and python3 arriving via the installs layer,
so that the base changes only when che or the session user does.

## As a session user

Works in the session shell. Builds no images.

### The shell is the session user's own (tested)

I want the session shell running as the session user in that user's home,
so that nothing runs as root by default.

### Root is one sudo away when the work needs it (implemented)

I want passwordless sudo for the session user,
so that the pod boundary carries the risk, not a password prompt.

### Root-group files are readable without escalation (implemented)

I want the session user in the root group,
so that ordinary work does not reach for sudo.

<!--[<] 🤖🤖 -->
